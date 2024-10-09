import 'dart:convert';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:m_food/package/scroll_date_picker_custom.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:m_food/a07_account_customer/a07_02_open_account/a07021_map_widget.dart';
import 'package:m_food/a07_account_customer/a07_02_open_account/widget/dropdown_custom.dart';
import 'package:m_food/components/step_approve_widget.dart';
import 'package:m_food/controller/category_product_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/custom_text.dart';
import 'package:m_food/widgets/format_method.dart';
import 'package:m_food/widgets/watermark_paint.dart';
import 'package:open_file/open_file.dart';
import 'package:photo_view/photo_view.dart';
import 'package:quickalert/quickalert.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:m_food/widgets/widget_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'form_open_new_customer_model.dart';
export 'form_open_new_customer_model.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart'
    as google_maps;
import 'package:google_maps_flutter_platform_interface/src/types/ui.dart'
    as ui_maps;
import 'package:geocoding/geocoding.dart';

class FormOpenNewCustomerEditOLD extends StatefulWidget {
  final Map<String, dynamic>? entryMap;
  final String? type;
  const FormOpenNewCustomerEditOLD(
      {@required this.type, @required this.entryMap, Key? key})
      : super(key: key);

  @override
  _FormOpenNewCustomerEditOLDState createState() =>
      _FormOpenNewCustomerEditOLDState();
}

class _FormOpenNewCustomerEditOLDState extends State<FormOpenNewCustomerEditOLD> {
  bool checkIDforAddress = false;
  TextEditingController houseNumber = TextEditingController();

  TextEditingController? moo = TextEditingController();
  TextEditingController? nameMoo = TextEditingController();
  TextEditingController? raod = TextEditingController();
  TextEditingController? province = TextEditingController();
  TextEditingController? district = TextEditingController();
  TextEditingController? subDistrict = TextEditingController();

  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;
  late FormOpenNewCustomerModel _model;

  //==============================================================================

  List<Completer<GoogleMapController>> _mapController = [];
  List<CameraPosition> _kGooglePlexDialog = [];
  List<Set<Marker>> markersDialog = [];
  List<Key> _mapKeyDialog = [];

  List<TextEditingController> searchMap = [];

  // //===============================================================================

  //======================================================
  // ตัวแปร ไว้เก็บค่าจาก dropdown ออกใบกำกับภาษีแต่ละที่อยู่
  List<FormFieldController<String>> dropDownControllersBillTax = [
    // FormFieldController<String>('')
  ];

  List<String?> listBillTaxIndex = [];

  // Completer<GoogleMapController> _mapController =
  //     Completer<GoogleMapController>();

  // Completer<GoogleMapController> mapController2 =
  //     Completer<GoogleMapController>();boolEditApprove
  // late CameraPosition _kGooglePlex;

  // Set<Marker> markers = Set<Marker>();

  final _formKey = GlobalKey<FormState>();
  // Key _mapKeyDialog = GlobalKey();
  // Key _mapKey = GlobalKey();

  // //==============================================================================

  // final Completer<GoogleMapController> _mapControllerDialog =
  //     Completer<GoogleMapController>();
  // late CameraPosition _kGooglePlexDialog;

  // Set<Marker> markersDialog = Set<Marker>();

  // //=================================================================================

  bool boolEditApprove = false;

  final categoryProductController = Get.find<CategoryProductController>();
  RxMap<String, dynamic>? categoryProduct;
  bool isLoading = false;

  // @override
  // void setState(VoidCallback callback) {
  //   super.setState(callback);
  //   _model.onUpdate();
  // }
  //========================================================
  String checkID = '';

  PhoneNumber number = PhoneNumber();
  List<PhoneNumber?>? phoneList = [];

  bool checkTimeToSend = false;

  List<String> productTypeEmployee = [];
  List<String?>? productTypeFinal = [];
  List<FocusNode?>? textFieldFocusProductType = [FocusNode()];

  //============= สำหรับ dropdown รูปภาพที่ไว้อ้างอิงแก่่่สถานที่ร้านค้าท้งหมด =========
  List<FormFieldController<String>> dropDownControllersimageAddress = [];
  List<String> imageAddressAllForDropdown = [];
  bool checkSummit = false;
  //===================================================================
  //===================================================================
  //=====================================================

  List<bool> chooseCheckProvice = [];
  List<bool> chooseCheckDistrice = [];
  List<bool> chooseCheckSubDistrice = [];

  List<TextEditingController?>? addressProvincesStringControllerType = [];
  List<TextEditingController?>? addressAmphuresStringControllerType = [];
  List<TextEditingController?>? addressTambonsStringControllerType = [];

  List<List<String>> provincesString = [];
  List<List<String>> amphuresString = [];
  List<List<String>> tambonsString = [];

  //=====================================================
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

  //===================================================================
  List<FocusNode?>? textFieldFocusSaka = [];
  List<FocusNode?>? textFieldFocusNameSaka = [];
  List<FocusNode?>? textFieldFocusRoad = [];
  List<FocusNode?>? textFieldFocusNameContract = [];
  List<FocusNode?>? textFieldFocusType = [];

  List<TextEditingController?>? textFieldControllerPhoneAddress = [];
  List<FocusNode?>? textFieldFocusPhone = [];

  List<FocusNode?>? textFieldFocusHouseNumber = [];
  List<FocusNode?>? textFieldFocusHouseMoo = [];

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

  //============== ประเภทสินค้าที่ขายในปัจจุบัน =================================
  List<TextEditingController?>? productType = [];

  //===================================================================

  List<FormFieldController<String>> dropDownControllersPriceTable = [];

  List<TextEditingController?>? latList = [];
  List<TextEditingController?>? lotList = [];

  List<String> addressAllForDropdown = [];
  List<String?> addressAllForDropdownForCheckIndex = [];

  int total4 = 1;

  List<Map<String, dynamic>> resultListSendAndBill = [];
  List<FormFieldController<String>> dropDownControllersSend = [];
  List<FormFieldController<String>> dropDownControllersBill = [];
  List<TextEditingController?>? sendAndBillList = [];

  List<FocusNode?>? textFieldFocusSendAndBill = [];

  //=====================================================

  //======================= รูปภาพของที่อยู่ทั้งหมด ==============================
  Reference? refNew;
  List<List<File?>?>? imageAddressList = [];
  List<List<Uint8List?>?>? imageAddressUint8List = [];
  List<List<String?>?>? imageAddressNetwork = [];

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

  List<FilePickerResult?> finalFileResult = List.filled(5, null);
  List<List<String>?>? finalFileResultString = List.generate(5, (_) => []);
  List<List<String>?>? fileUrlFromFirestoreList = List.generate(5, (_) => []);

  Reference? ref4;

  //======================================================================
  List<List<XFile?>?>? imageFileList2 = List.generate(5, (_) => []);
  List<List<File?>?>? imageList2 = List.generate(5, (_) => []);
  List<List<Uint8List?>?>? imageUint8ListList2 = List.generate(5, (_) => []);
  List<List<String>?>? imageUrlFromFirestoreList2 = List.generate(5, (_) => []);
  Reference? ref3;

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

  bool signConfirm = false;

  Image? imageSignToShow;

  String base64ImgSign = '';
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

  Map<String, dynamic> selectedFirst = {
    'province_id': null,
    'amphure_id': null,
    'tambon_id': null,
  };

  List<dynamic>? provincesFirst = [];

  List<String> provincesListFirst = [];
  List<dynamic>? amphuresListFirst = [];
  List<dynamic>? tambonsListFirst = [];

  //================================= ตัวแปร controller หลังบัตรประชาชน ในส่วนใหม่ 20 02 2567 ====================================

  TextEditingController? homeAddress = TextEditingController();
  TextEditingController? mooAddress = TextEditingController();
  TextEditingController? nameMooAddress = TextEditingController();
  TextEditingController? roadAddress = TextEditingController();
  TextEditingController? proviceAddress = TextEditingController();
  TextEditingController? districAddressController = TextEditingController();
  String? districAddress;
  String? subDistricAddress;
  TextEditingController? subDistricAddressController = TextEditingController();
  TextEditingController? codeAddress = TextEditingController();

  List<TextEditingController?>? postalCodeController = [];

  DateTime dateBirthday = DateTime.now();

  //==OCR===========================
  Map textMap = {
    'idcard': '',
    'sex': '',
    'name': '',
    'surname': '',
    'day': '',
    'month': '',
    'year': '',
    'birthday': '',
    'address': '',
    'subdist': '',
    'dist': '',
    'province': '',
    'province_id': '',
    'dist_id': '',
    'subdist_id': ''
  };

  //=====================================================================
  bool checkStatusToEdit = false;
  bool checkStatusToButtonEdit = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FormOpenNewCustomerModel());

    loadData();
  }

  ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void scrollUp() {
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  }

  //======================================================================
  List<String> dropdownPay = []; //dropdown api
  Map<String, dynamic> dataPay = {};
  Map<String, dynamic> data2 = {};
  List<String> dropdown2 = [];
  Map<String, dynamic> data3 = {};
  List<String> dropdown3 = [];
  Map<String, dynamic> data4 = {};
  List<String> dropdown4 = [];
  Map<String, dynamic> data5 = {};
  List<String> dropdown5 = [];

  Map<String, dynamic> dataGroup1 = {};
  List<String> dropdownGroup1 = ['ยกเลิก'];
  Map<String, dynamic> dataGroup2 = {};
  List<String> dropdownGroup2 = ['ยกเลิก'];
  Map<String, dynamic> dataGroup3 = {};
  List<String> dropdownGroup3 = ['ยกเลิก'];
  Map<String, dynamic> dataGroup4 = {};
  List<String> dropdownGroup4 = ['ยกเลิก'];
  Map<String, dynamic> dataGroup5 = {};
  List<String> dropdownGroup5 = ['ยกเลิก'];

  Map<String, dynamic> priceTable = {};
  List<String> priceTableName = [];

  Future<void> fetchData() async {
    QuerySnapshot apploveQuerySnapshot =
        await FirebaseFirestore.instance.collection('ApproveComment').get();

    Map<String, dynamic> dataApplove = {};

    for (int index = 0; index < apploveQuerySnapshot.docs.length; index++) {
      final Map<String, dynamic> docData =
          apploveQuerySnapshot.docs[index].data() as Map<String, dynamic>;

      if (docData['CustomerID'] == widget.entryMap!['value']['CustomerID']) {
        dataApplove['key${index}'] = docData;
      }
    }
    print('Approve Comment');
    print(dataApplove);
    List<MapEntry<String, dynamic>> entriesList = dataApplove.entries.toList();

    for (var entry in entriesList) {
      if (entry.value['PositionName'] == 'ผู้อนุมัติคนที่ 5' &&
          entry.value['ยื่นเอกสารใหม่'] == false) {
        setState(() {
          boolEditApprove = true;
        });
      }
    }
    print('===============================');
    print('===============================');
    print('===============================');
    print('===============================');
    print('===============================');
    print('===============================');
    print('===============================');
    print('===============================');
    print('===============================');
    print('===============================');
    print('===============================');
    print('===============================');
    print(boolEditApprove);

    print('===============================');
    print('===============================');
    print('===============================');
    print('===============================');

    //======================================================================
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('เงื่อนไขการชำระเงิน')
        .get();

    for (int index = 0; index < querySnapshot.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshot.docs[index].data() as Map<String, dynamic>;

      if (docData['PTERM_DESC'] != '' && docData['IS_ACTIVE'] == true) {
        dataPay['key$index'] = docData;
        dropdownPay.add(docData['PTERM_DESC']);
      }
    }
    //======================================================================

    QuerySnapshot querySnapshot2 =
        await FirebaseFirestore.instance.collection('ประเภทการจ่ายเงิน').get();

    for (int index = 0; index < querySnapshot2.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshot2.docs[index].data() as Map<String, dynamic>;

      if (docData['PAYMENT_DESC'] != '') {
        data2['key${index}'] = docData;
        dropdown2.add(docData['PAYMENT_DESC']);
      }
    }

    //======================================================================

    QuerySnapshot querySnapshot3 = await FirebaseFirestore.instance
        .collection('บัญชีธนาคารของบริษัท')
        .get();

    for (int index = 0; index < querySnapshot3.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshot3.docs[index].data() as Map<String, dynamic>;

      if (docData['BBOOK_DESC'] != '' && docData['RESULT'] == true) {
        data3['key${index}'] = docData;
        dropdown3.add(docData['BBOOK_DESC']);
      }
    }
    //======================================================================

    QuerySnapshot querySnapshot4 =
        await FirebaseFirestore.instance.collection('แผนก').get();
    for (int index = 0; index < querySnapshot4.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshot4.docs[index].data() as Map<String, dynamic>;

      if (docData['DEPARTMENT_NAME'] != '' && docData['IS_ACTIVE'] == true) {
        data4['key${index}'] = docData;
        dropdown4.add(docData['DEPARTMENT_NAME']);
      }
    }

    //======================================================================
    QuerySnapshot querySnapshot5 =
        await FirebaseFirestore.instance.collection('รหัสบัญชี').get();

    for (int index = 0; index < querySnapshot5.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshot5.docs[index].data() as Map<String, dynamic>;

      if (docData['ACC_DESC'] != '') {
        data5['key${index}'] = docData;
        dropdown5.add(docData['ACC_DESC']);
      }
    }
    //======================================================================
    QuerySnapshot querySnapshotGroup1 = await FirebaseFirestore.instance
        .collection('รหัสกลุ่มลูกค้าที่1')
        .get();

    for (int index = 0; index < querySnapshotGroup1.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshotGroup1.docs[index].data() as Map<String, dynamic>;

      if (docData['GROUP_DESC'] != '' && docData['IS_ACTIVE'] == true) {
        dataGroup1['key${index}'] = docData;
        dropdownGroup1.add(docData['GROUP_DESC']);
      }
    } //======================================================================
    QuerySnapshot querySnapshotGroup2 = await FirebaseFirestore.instance
        .collection('รหัสกลุ่มลูกค้าที่2')
        .get();

    for (int index = 0; index < querySnapshotGroup2.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshotGroup2.docs[index].data() as Map<String, dynamic>;

      if (docData['GROUP_DESC'] != '' && docData['IS_ACTIVE'] == true) {
        dataGroup2['key${index}'] = docData;
        dropdownGroup2.add(docData['GROUP_DESC']);
      }
    }
    //======================================================================
    QuerySnapshot querySnapshotGroup3 = await FirebaseFirestore.instance
        .collection('รหัสกลุ่มลูกค้าที่3')
        .get();

    for (int index = 0; index < querySnapshotGroup3.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshotGroup3.docs[index].data() as Map<String, dynamic>;

      if (docData['GROUP_DESC'] != '' && docData['IS_ACTIVE'] == true) {
        dataGroup3['key${index}'] = docData;
        dropdownGroup3.add(docData['GROUP_DESC']);
      }
    }

    //======================================================================
    QuerySnapshot querySnapshotGroup4 = await FirebaseFirestore.instance
        .collection('รหัสกลุ่มลูกค้าที่4')
        .get();

    for (int index = 0; index < querySnapshotGroup4.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshotGroup4.docs[index].data() as Map<String, dynamic>;

      if (docData['GROUP_DESC'] != '' && docData['IS_ACTIVE'] == true) {
        dataGroup4['key${index}'] = docData;
        dropdownGroup4.add(docData['GROUP_DESC']);
      }
    }

    //======================================================================
    QuerySnapshot querySnapshotGroup5 = await FirebaseFirestore.instance
        .collection('รหัสกลุ่มลูกค้าที่5')
        .get();

    for (int index = 0; index < querySnapshotGroup5.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshotGroup5.docs[index].data() as Map<String, dynamic>;

      if (docData['GROUP_DESC'] != '' && docData['IS_ACTIVE'] == true) {
        dataGroup5['key${index}'] = docData;
        dropdownGroup5.add(docData['GROUP_DESC']);
      }
    }
    //======================================================================
    QuerySnapshot querySnapshotTable =
        await FirebaseFirestore.instance.collection('ตารางราคา').get();
    for (int index = 0; index < querySnapshotTable.docs.length; index++) {
      final Map<String, dynamic> docData =
          querySnapshotTable.docs[index].data() as Map<String, dynamic>;

      if (docData['PLIST_DESC2'] != '') {
        priceTable['key${index}'] = docData;
        priceTableName.add(docData['PLIST_DESC2']);
      }
    }
  }

  void loadData() async {
    try {
      setState(() {
        isLoading = true;
      });
      //=====================================================================

      print('fetchData');
      await fetchData();

      if (widget.entryMap!['value']['ใช้ที่อยู่ตามบัตร'] == null) {
      } else {
        checkIDforAddress = widget.entryMap!['value']['ใช้ที่อยู่ตามบัตร'];
      }

      homeAddress =
          TextEditingController(text: widget.entryMap!['value']['บ้านเลขที่']);
      print('--------------');
      print('--------------');
      print(homeAddress.text);
      print(homeAddress.text);
      print(homeAddress.text);
      print(homeAddress.text);
      print(homeAddress.text);
      print(homeAddress.text);
      print('--------------');
      print('--------------');

      mooAddress =
          TextEditingController(text: widget.entryMap!['value']['หมู่']);
      nameMooAddress =
          TextEditingController(text: widget.entryMap!['value']['หมู่บ้าน']);
      roadAddress =
          TextEditingController(text: widget.entryMap!['value']['ถนน']);
      proviceAddress =
          TextEditingController(text: widget.entryMap!['value']['จังหวัด']);
      districAddressController =
          TextEditingController(text: widget.entryMap!['value']['อำเภอ']);
      // districAddress;
      // subDistricAddress;
      subDistricAddressController =
          TextEditingController(text: widget.entryMap!['value']['ตำบล']);
      codeAddress = TextEditingController(
          text: widget.entryMap!['value']['รหัสไปรษณีย์']);

      var response = await DefaultAssetBundle.of(context)
          .loadString('assets/thai_province_data.json.txt');
      var result = json.decode(response);
      provinces = result;
      provinces?.sort((a, b) {
        String nameA = a['name_th'];
        String nameB = b['name_th'];

        return nameA.compareTo(nameB);
      });

      provinces!.forEach((element) {
        String text = '${element['name_th']} - ${element['name_en']}';

        provincesListFirst.add(text);
      });

      print(widget.entryMap!['value']['จังหวัด']);
      print(widget.entryMap!['value']['จังหวัด']);
      print(widget.entryMap!['value']['จังหวัด']);
      print(widget.entryMap!['value']['จังหวัด']);

      // print(provinces);

      if (widget.entryMap!['value']['จังหวัด'] == '' ||
          widget.entryMap!['value']['จังหวัด'] == null) {
      } else {
        String nameThOnly =
            widget.entryMap!['value']['จังหวัด'].split(' - ')[0];

        Map<String, dynamic> parent =
            provinces!.firstWhere((item) => item['name_th'] == nameThOnly);
        // print(parent);

        // List<dynamic> childs = parent['amphure'];
        // print('parent');
        // print('parent');
        // print('parent');
        // print('parent');

        // print(parent['amphure']);

        amphuresListFirst = parent['amphure'];

        // print(amphuresListFirst);

        if (widget.entryMap!['value']['อำเภอ'] == '' ||
            widget.entryMap!['value']['อำเภอ'] == null) {
        } else {
          String nameThOnlyAmphor =
              widget.entryMap!['value']['อำเภอ'].split(' - ')[0];

          // print(nameThOnlyAmphor);
          // print(nameThOnlyAmphor);
          // print(nameThOnlyAmphor);
          // print(nameThOnlyAmphor);

          Map<String, dynamic> parentAmphor = amphuresListFirst!
              .firstWhere((item) => item['name_th'] == nameThOnlyAmphor);

          districAddress = parentAmphor['id'].toString();

          tambonsListFirst = parentAmphor['tambon'];

          if (widget.entryMap!['value']['ตำบล'] == '' ||
              widget.entryMap!['value']['ตำบล'] == null) {
          } else {
            String nameThOnlyTambon =
                widget.entryMap!['value']['ตำบล'].split(' - ')[0];

            Map<String, dynamic> parentTambon = tambonsListFirst!
                .firstWhere((item) => item['name_th'] == nameThOnlyTambon);

            subDistricAddress = parentTambon['id'].toString();
          }
        }
      }

      if (userData!['ประเภทสินค้า'] == null) {
      } else {
        for (int i = 0; i < userData!['ประเภทสินค้า'].length; i++) {
          productTypeEmployee.add(userData!['ประเภทสินค้า'][i]);
        }
        productTypeEmployee.sort((a, b) {
          String nameA = a;
          String nameB = b;

          return nameA.compareTo(nameB);
        });
      }

      // print(productTypeEmployee);
      // print(productTypeEmployee);
      // print(productTypeEmployee);
      // print(productTypeEmployee);

      // categoryProduct = categoryProductController.categoryProductsData;

      // for (int i = 0; i < categoryProduct!.length; i++) {
      //   print(categoryProduct);
      //   categoryNameList.add(categoryProduct!['key${i}']['GROUP_DESC']);
      // }
      //=====================================================================

      imageLength = widget.entryMap!['value']['รูปร้านค้า'].length;

      for (int i = 0; i < imageLength; i++) {
        imageAddressAllForDropdown.add('รูปภาพ ${i + 1}');
      }
      //=====================================================================

      if (widget.entryMap!['value']['ListCustomerAddress'].length == 0) {
        // print('ไม่มีประวัติ');
        resultList.add({
          'ID': DateTime.now().toString(),
          'รหัสสาขา': '', //new
          'ชื่อสาขา': '', //new
          'HouseNumber': '',
          'Moo': '',
          'VillageName': '',
          'Road': '', //new
          'Province': '',
          'District': '',
          'SubDistrict': '',
          'PostalCode': '',
          'Latitude': '',
          'Longitude': '',
          'Image': '',
          'ผู้ติดต่อ': '', //new
          'ตำแหน่ง': '', //new
          'หัวข้อโทรศัพท์': '', //new
          'โทรศัพท์': '', //new
          'ตารางราคา': '',
          'ที่อยู่จัดส่งและออกใบกำกับภาษี': '',
        });

        _mapController.add(Completer<GoogleMapController>());
        _kGooglePlexDialog.add(CameraPosition(
          target: google_maps.LatLng(13.7563309, 100.5017651),
          zoom: 14.4746,
        ));
        markersDialog.add(Set<Marker>());
        _mapKeyDialog.add(GlobalKey());

        searchMap.add(TextEditingController());

        selected.add({
          'province_id': null,
          'amphure_id': null,
          'tambon_id': null,
        });
        // print('5555555555');
        // print(resultList);
        postalCodeController!.add(TextEditingController());
        amphures!.add([]);
        tambons!.add([]);

        imageAddressList!.add([]);
        imageAddressUint8List!.add([]);
        imageAddressNetwork!.add([]);

        dropDownControllersPriceTable.add(FormFieldController(null));

        dropDownControllersBillTax.add(FormFieldController(null));

        listBillTaxIndex.add('ไม่ได้เลือก');

        latList!.add(TextEditingController());
        lotList!.add(TextEditingController());

        //===================================================================
        // print('object');
        phoneList!.add(PhoneNumber(isoCode: 'TH'));

        // print(phoneList);

        textFieldFocusSaka!.add(FocusNode());
        textFieldFocusNameSaka!.add(FocusNode());
        textFieldFocusRoad!.add(FocusNode());
        textFieldFocusNameContract!.add(FocusNode());
        textFieldFocusType!.add(FocusNode());

        textFieldControllerPhoneAddress!.add(TextEditingController());

        textFieldFocusPhone!.add(FocusNode());
        textFieldFocusHouseNumber!.add(FocusNode());
        textFieldFocusHouseMoo!.add(FocusNode());

        textFieldFocusVillageName!.add(FocusNode());
        textFieldFocusPostalCode!.add(FocusNode());
        textFieldFocusLatitude!.add(FocusNode());
        textFieldFocusLongitude!.add(FocusNode());

        dropDownControllersimageAddress.add(FormFieldController<String>(''));

        addressProvincesStringControllerType!.add(TextEditingController());
        provincesString.add([]);
      } else {
        for (int i = 0;
            i < widget.entryMap!['value']['ListCustomerAddress'].length;
            i++) {
          //========================================================

          listBillTaxIndex.add(widget.entryMap!['value']['ListCustomerAddress']
              [i]['indexที่อยู่จัดส่งและออกใบกำกับภาษี']);

          // print('---------------------------------------------------------');
          //========================================================
          if (widget.entryMap!['value']['ListCustomerAddress'][i]['Latitude'] ==
                  null ||
              widget.entryMap!['value']['ListCustomerAddress'][i]['Latitude'] ==
                  '') {
            _mapController.add(Completer<GoogleMapController>());
            _kGooglePlexDialog.add(CameraPosition(
              target: google_maps.LatLng(13.7563309, 100.5017651),
              zoom: 14.4746,
            ));
            markersDialog.add(Set<Marker>());
            _mapKeyDialog.add(GlobalKey());

            searchMap.add(TextEditingController());
          } else {
            _mapController.add(Completer<GoogleMapController>());
            _kGooglePlexDialog.add(CameraPosition(
              target: google_maps.LatLng(
                  double.parse(widget.entryMap!['value']['ListCustomerAddress']
                      [i]['Latitude']),
                  double.parse(widget.entryMap!['value']['ListCustomerAddress']
                      [i]['Longitude'])),
              zoom: 14.4746,
            ));

            Set<Marker> markerSet = Set<Marker>();
            markerSet.add(
              Marker(
                markerId: MarkerId("your_marker_id"),
                position: google_maps.LatLng(
                    double.parse(widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['Latitude']),
                    double.parse(widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['Longitude'])),
                infoWindow: InfoWindow(
                  title: '',
                ),
              ),
            );
            markersDialog.add(markerSet);

            _mapKeyDialog.add(GlobalKey());

            searchMap.add(TextEditingController());
          }

          if (widget.entryMap!['value']['รูปร้านค้า'].length != 0) {
            if (widget.entryMap!['value']['ListCustomerAddress'].length >
                widget.entryMap!['value']['รูปร้านค้า'].length) {
              if ((i + 1) > widget.entryMap!['value']['รูปร้านค้า'].length) {
                resultList.add({
                  'ID': widget.entryMap!['value']['ListCustomerAddress'][i]
                      ['ID'], //new
                  'รหัสสาขา': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['รหัสสาขา'], //new
                  'ชื่อสาขา': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['ชื่อสาขา'], //new
                  'HouseNumber': widget.entryMap!['value']
                      ['ListCustomerAddress'][i]['HouseNumber'],

                  'Moo': widget.entryMap!['value']['ListCustomerAddress'][i]
                              ['Moo'] ==
                          null
                      ? ''
                      : widget.entryMap!['value']['ListCustomerAddress'][i]
                          ['Moo'],

                  'VillageName': widget.entryMap!['value']
                      ['ListCustomerAddress'][i]['VillageName'],
                  'Road': widget.entryMap!['value']['ListCustomerAddress'][i]
                      ['Road'], //new
                  'Province': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['Province'],
                  'District': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['District'],
                  'SubDistrict': widget.entryMap!['value']
                      ['ListCustomerAddress'][i]['SubDistrict'],
                  'PostalCode': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['PostalCode'],
                  'Latitude': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['Latitude'],
                  'Longitude': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['Longitude'],
                  'Image': '',
                  'ผู้ติดต่อ': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['ผู้ติดต่อ'], //new
                  'ตำแหน่ง': widget.entryMap!['value']['ListCustomerAddress'][i]
                      ['ตำแหน่ง'], //new
                  'หัวข้อโทรศัพท์': widget.entryMap!['value']
                              ['ListCustomerAddress'][i]['หัวข้อโทรศัพท์'] ==
                          null
                      ? ''
                      : widget.entryMap!['value']['ListCustomerAddress'][i]
                          ['หัวข้อโทรศัพท์'], //new
                  'โทรศัพท์': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['โทรศัพท์'], //new

                  'ตารางราคา': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['ตารางราคา'],
                  'ที่อยู่จัดส่งและออกใบกำกับภาษี': widget.entryMap!['value']
                          ['ListCustomerAddress'][i]
                      ['ที่อยู่จัดส่งและออกใบกำกับภาษี']
                });

                //===================================================

                // _mapController.add(Completer<GoogleMapController>());

                // _kGooglePlexDialog.add(CameraPosition(
                //   target: google_maps.LatLng(
                //       double.parse(widget.entryMap!['value']
                //           ['ListCustomerAddress'][i]['Latitude']),
                //       double.parse(widget.entryMap!['value']
                //           ['ListCustomerAddress'][i]['Longitude'])),
                //   zoom: 14.4746,
                // ));

                // Set<Marker> markerSet = Set<Marker>();
                // markerSet.add(
                //   Marker(
                //     markerId: MarkerId("your_marker_id"),
                //     position: google_maps.LatLng(
                //         double.parse(widget.entryMap!['value']
                //             ['ListCustomerAddress'][i]['Latitude']),
                //         double.parse(widget.entryMap!['value']
                //             ['ListCustomerAddress'][i]['Longitude'])),
                //     infoWindow: InfoWindow(
                //       title: '',
                //     ),
                //   ),
                // );
                // markersDialog.add(markerSet);

                // _mapKeyDialog.add(GlobalKey());

                // searchMap.add(TextEditingController());

                //===================================================

                dropDownControllersimageAddress
                    .add(FormFieldController<String>(''));

                print('1');
                if (widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['โทรศัพท์'] ==
                    '') {
                  phoneList!.add(PhoneNumber(isoCode: 'TH'));
                } else {
                  if (widget
                          .entryMap!['value']['ListCustomerAddress'][i]
                              ['โทรศัพท์']
                          .length <
                      10) {
                    phoneList!.add(PhoneNumber(isoCode: 'TH'));
                  } else {
                    phoneList!.add(
                        await PhoneNumber.getRegionInfoFromPhoneNumber(
                            widget.entryMap!['value']['ListCustomerAddress'][i]
                                ['โทรศัพท์'],
                            'TH'));
                  }
                }
                print('2');

                textFieldControllerPhoneAddress!.add(TextEditingController(
                    text: widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['โทรศัพท์']));
                print('3');
              } else {
                if (widget.entryMap!['value']['รูปร้านค้า'][i] == '') {
                  resultList.add({
                    'ID': widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['ID'], //new
                    'รหัสสาขา': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['รหัสสาขา'], //new
                    'ชื่อสาขา': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['ชื่อสาขา'], //new
                    'HouseNumber': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['HouseNumber'],

                    'Moo': widget.entryMap!['value']['ListCustomerAddress'][i]
                                ['Moo'] ==
                            null
                        ? ''
                        : widget.entryMap!['value']['ListCustomerAddress'][i]
                            ['Moo'],

                    'VillageName': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['VillageName'],
                    'Road': widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['Road'], //new
                    'Province': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['Province'],
                    'District': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['District'],
                    'SubDistrict': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['SubDistrict'],
                    'PostalCode': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['PostalCode'],
                    'Latitude': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['Latitude'],
                    'Longitude': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['Longitude'],
                    'Image': widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['Image'],
                    'ผู้ติดต่อ': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['ผู้ติดต่อ'], //new
                    'ตำแหน่ง': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['ตำแหน่ง'], //new
                    'หัวข้อโทรศัพท์': widget.entryMap!['value']
                                ['ListCustomerAddress'][i]['หัวข้อโทรศัพท์'] ==
                            null
                        ? ''
                        : widget.entryMap!['value']['ListCustomerAddress'][i]
                            ['หัวข้อโทรศัพท์'], //new
                    'โทรศัพท์': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['โทรศัพท์'], //new

                    'ตารางราคา': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['ตารางราคา'],
                    'ที่อยู่จัดส่งและออกใบกำกับภาษี': widget.entryMap!['value']
                            ['ListCustomerAddress'][i]
                        ['ที่อยู่จัดส่งและออกใบกำกับภาษี']
                  });

                  // //===================================================

                  // _mapController.add(Completer<GoogleMapController>());

                  // _kGooglePlexDialog.add(CameraPosition(
                  //   target: google_maps.LatLng(
                  //       double.parse(widget.entryMap!['value']
                  //           ['ListCustomerAddress'][i]['Latitude']),
                  //       double.parse(widget.entryMap!['value']
                  //           ['ListCustomerAddress'][i]['Longitude'])),
                  //   zoom: 14.4746,
                  // ));

                  // Set<Marker> markerSet = Set<Marker>();
                  // markerSet.add(
                  //   Marker(
                  //     markerId: MarkerId("your_marker_id"),
                  //     position: google_maps.LatLng(
                  //         double.parse(widget.entryMap!['value']
                  //             ['ListCustomerAddress'][i]['Latitude']),
                  //         double.parse(widget.entryMap!['value']
                  //             ['ListCustomerAddress'][i]['Longitude'])),
                  //     infoWindow: InfoWindow(
                  //       title: '',
                  //     ),
                  //   ),
                  // );
                  // markersDialog.add(markerSet);

                  // _mapKeyDialog.add(GlobalKey());

                  // searchMap.add(TextEditingController());

                  // //===================================================
                  dropDownControllersimageAddress
                      .add(FormFieldController<String>(''));

                  // phoneList!.add(PhoneNumber(
                  //     isoCode: 'TH',
                  //     dialCode: widget.entryMap!['value']['ListCustomerAddress']
                  //                 [i]['หัวข้อโทรศัพท์'] ==
                  //             null
                  //         ? ''
                  //         : widget.entryMap!['value']['ListCustomerAddress'][i]
                  //             ['หัวข้อโทรศัพท์'],
                  //     phoneNumber: '+66' +
                  //         widget.entryMap!['value']['ListCustomerAddress'][i]
                  //             ['โทรศัพท์']));
                  print('4');

                  if (widget.entryMap!['value']['ListCustomerAddress'][i]
                          ['โทรศัพท์'] ==
                      '') {
                    phoneList!.add(PhoneNumber(isoCode: 'TH'));
                  } else {
                    if (widget
                            .entryMap!['value']['ListCustomerAddress'][i]
                                ['โทรศัพท์']
                            .length <
                        10) {
                      phoneList!.add(PhoneNumber(isoCode: 'TH'));
                    } else {
                      phoneList!.add(
                          await PhoneNumber.getRegionInfoFromPhoneNumber(
                              widget.entryMap!['value']['ListCustomerAddress']
                                  [i]['โทรศัพท์'],
                              'TH'));
                    }
                  }

                  textFieldControllerPhoneAddress!.add(TextEditingController(
                      text: widget.entryMap!['value']['ListCustomerAddress'][i]
                          ['โทรศัพท์']));
                } else {
                  resultList.add({
                    'ID': widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['ID'], //new
                    'รหัสสาขา': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['รหัสสาขา'], //new
                    'ชื่อสาขา': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['ชื่อสาขา'], //new
                    'HouseNumber': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['HouseNumber'],

                    'Moo': widget.entryMap!['value']['ListCustomerAddress'][i]
                                ['Moo'] ==
                            null
                        ? ''
                        : widget.entryMap!['value']['ListCustomerAddress'][i]
                            ['Moo'],

                    'VillageName': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['VillageName'],
                    'Road': widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['Road'], //new
                    'Province': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['Province'],
                    'District': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['District'],
                    'SubDistrict': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['SubDistrict'],
                    'PostalCode': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['PostalCode'],
                    'Latitude': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['Latitude'],
                    'Longitude': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['Longitude'],
                    // 'Image': '',
                    'Image': widget.entryMap!['value']['รูปร้านค้า'].indexOf(
                                widget.entryMap!['value']['ListCustomerAddress']
                                    [i]['Image']) !=
                            -1
                        ? (widget.entryMap!['value']['รูปร้านค้า'].indexOf(
                                    widget.entryMap!['value']
                                        ['ListCustomerAddress'][i]['Image']) +
                                1)
                            .toString()
                        : '',
                    'ผู้ติดต่อ': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['ผู้ติดต่อ'], //new
                    'ตำแหน่ง': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['ตำแหน่ง'], //new
                    'หัวข้อโทรศัพท์': widget.entryMap!['value']
                                ['ListCustomerAddress'][i]['หัวข้อโทรศัพท์'] ==
                            null
                        ? ''
                        : widget.entryMap!['value']['ListCustomerAddress'][i]
                            ['หัวข้อโทรศัพท์'], //new
                    'โทรศัพท์': widget.entryMap!['value']['ListCustomerAddress']
                        [i]['โทรศัพท์'], //new

                    'ตารางราคา': widget.entryMap!['value']
                        ['ListCustomerAddress'][i]['ตารางราคา'],
                    'ที่อยู่จัดส่งและออกใบกำกับภาษี': widget.entryMap!['value']
                            ['ListCustomerAddress'][i]
                        ['ที่อยู่จัดส่งและออกใบกำกับภาษี']
                  });
                  dropDownControllersimageAddress.add(FormFieldController<
                          String>(
                      'รูปภาพ ${widget.entryMap!['value']['รูปร้านค้า'].indexOf(widget.entryMap!['value']['ListCustomerAddress'][i]['Image']) + 1}'));
                  // phoneList!.add(PhoneNumber(
                  //     isoCode: 'TH',
                  //     dialCode: widget.entryMap!['value']['ListCustomerAddress']
                  //                 [i]['หัวข้อโทรศัพท์'] ==
                  //             null
                  //         ? ''
                  //         : widget.entryMap!['value']['ListCustomerAddress'][i]
                  //             ['หัวข้อโทรศัพท์'],
                  //     phoneNumber: '+66' +
                  //         widget.entryMap!['value']['ListCustomerAddress'][i]
                  //             ['โทรศัพท์']));

                  print('5');

                  if (widget.entryMap!['value']['ListCustomerAddress'][i]
                          ['โทรศัพท์'] ==
                      '') {
                    phoneList!.add(PhoneNumber(isoCode: 'TH'));
                  } else {
                    if (widget
                            .entryMap!['value']['ListCustomerAddress'][i]
                                ['โทรศัพท์']
                            .length <
                        10) {
                      phoneList!.add(PhoneNumber(isoCode: 'TH'));
                    } else {
                      phoneList!.add(
                          await PhoneNumber.getRegionInfoFromPhoneNumber(
                              widget.entryMap!['value']['ListCustomerAddress']
                                  [i]['โทรศัพท์'],
                              'TH'));
                    }
                  }

                  textFieldControllerPhoneAddress!.add(TextEditingController(
                      text: widget.entryMap!['value']['ListCustomerAddress'][i]
                          ['โทรศัพท์']));
                }
              }
            } else {
              if (widget.entryMap!['value']['รูปร้านค้า'][i] == '') {
                resultList.add({
                  'ID': widget.entryMap!['value']['ListCustomerAddress'][i]
                      ['ID'], //new
                  'รหัสสาขา': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['รหัสสาขา'], //new
                  'ชื่อสาขา': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['ชื่อสาขา'], //new
                  'HouseNumber': widget.entryMap!['value']
                      ['ListCustomerAddress'][i]['HouseNumber'],

                  'Moo': widget.entryMap!['value']['ListCustomerAddress'][i]
                              ['Moo'] ==
                          null
                      ? ''
                      : widget.entryMap!['value']['ListCustomerAddress'][i]
                          ['Moo'],

                  'VillageName': widget.entryMap!['value']
                      ['ListCustomerAddress'][i]['VillageName'],
                  'Road': widget.entryMap!['value']['ListCustomerAddress'][i]
                      ['Road'], //new
                  'Province': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['Province'],
                  'District': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['District'],
                  'SubDistrict': widget.entryMap!['value']
                      ['ListCustomerAddress'][i]['SubDistrict'],
                  'PostalCode': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['PostalCode'],
                  'Latitude': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['Latitude'],
                  'Longitude': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['Longitude'],
                  'Image': widget.entryMap!['value']['ListCustomerAddress'][i]
                      ['Image'],
                  'ผู้ติดต่อ': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['ผู้ติดต่อ'], //new
                  'ตำแหน่ง': widget.entryMap!['value']['ListCustomerAddress'][i]
                      ['ตำแหน่ง'], //new
                  'หัวข้อโทรศัพท์': widget.entryMap!['value']
                              ['ListCustomerAddress'][i]['หัวข้อโทรศัพท์'] ==
                          null
                      ? ''
                      : widget.entryMap!['value']['ListCustomerAddress'][i]
                          ['หัวข้อโทรศัพท์'], //new
                  'โทรศัพท์': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['โทรศัพท์'], //new

                  'ตารางราคา': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['ตารางราคา'],
                  'ที่อยู่จัดส่งและออกใบกำกับภาษี': widget.entryMap!['value']
                          ['ListCustomerAddress'][i]
                      ['ที่อยู่จัดส่งและออกใบกำกับภาษี']
                });
                dropDownControllersimageAddress
                    .add(FormFieldController<String>(''));
                // phoneList!.add(PhoneNumber(
                //     isoCode: 'TH',
                //     dialCode: widget.entryMap!['value']['ListCustomerAddress']
                //                 [i]['หัวข้อโทรศัพท์'] ==
                //             null
                //         ? ''
                //         : widget.entryMap!['value']['ListCustomerAddress'][i]
                //             ['หัวข้อโทรศัพท์'],
                //     phoneNumber: '+66' +
                //         widget.entryMap!['value']['ListCustomerAddress'][i]
                //             ['โทรศัพท์']));

                print('6');

                if (widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['โทรศัพท์'] ==
                    '') {
                  phoneList!.add(PhoneNumber(isoCode: 'TH'));
                } else {
                  if (widget
                          .entryMap!['value']['ListCustomerAddress'][i]
                              ['โทรศัพท์']
                          .length <
                      10) {
                    phoneList!.add(PhoneNumber(isoCode: 'TH'));
                  } else {
                    phoneList!.add(
                        await PhoneNumber.getRegionInfoFromPhoneNumber(
                            widget.entryMap!['value']['ListCustomerAddress'][i]
                                ['โทรศัพท์'],
                            'TH'));
                  }
                }

                textFieldControllerPhoneAddress!.add(TextEditingController(
                    text: widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['โทรศัพท์']));
              } else {
                resultList.add({
                  'ID': widget.entryMap!['value']['ListCustomerAddress'][i]
                      ['ID'], //new
                  'รหัสสาขา': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['รหัสสาขา'], //new
                  'ชื่อสาขา': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['ชื่อสาขา'], //new
                  'HouseNumber': widget.entryMap!['value']
                      ['ListCustomerAddress'][i]['HouseNumber'],

                  'Moo': widget.entryMap!['value']['ListCustomerAddress'][i]
                              ['Moo'] ==
                          null
                      ? ''
                      : widget.entryMap!['value']['ListCustomerAddress'][i]
                          ['Moo'],

                  'VillageName': widget.entryMap!['value']
                      ['ListCustomerAddress'][i]['VillageName'],
                  'Road': widget.entryMap!['value']['ListCustomerAddress'][i]
                      ['Road'], //new
                  'Province': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['Province'],
                  'District': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['District'],
                  'SubDistrict': widget.entryMap!['value']
                      ['ListCustomerAddress'][i]['SubDistrict'],
                  'PostalCode': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['PostalCode'],
                  'Latitude': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['Latitude'],
                  'Longitude': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['Longitude'],
                  // 'Image': '',
                  'Image': widget.entryMap!['value']['รูปร้านค้า'].indexOf(
                              widget.entryMap!['value']['ListCustomerAddress']
                                  [i]['Image']) !=
                          -1
                      ? (widget.entryMap!['value']['รูปร้านค้า'].indexOf(
                                  widget.entryMap!['value']
                                      ['ListCustomerAddress'][i]['Image']) +
                              1)
                          .toString()
                      : '',
                  'ผู้ติดต่อ': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['ผู้ติดต่อ'], //new
                  'ตำแหน่ง': widget.entryMap!['value']['ListCustomerAddress'][i]
                      ['ตำแหน่ง'], //new
                  'หัวข้อโทรศัพท์': widget.entryMap!['value']
                              ['ListCustomerAddress'][i]['หัวข้อโทรศัพท์'] ==
                          null
                      ? ''
                      : widget.entryMap!['value']['ListCustomerAddress'][i]
                          ['หัวข้อโทรศัพท์'], //new
                  'โทรศัพท์': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['โทรศัพท์'], //new

                  'ตารางราคา': widget.entryMap!['value']['ListCustomerAddress']
                      [i]['ตารางราคา'],
                  'ที่อยู่จัดส่งและออกใบกำกับภาษี': widget.entryMap!['value']
                          ['ListCustomerAddress'][i]
                      ['ที่อยู่จัดส่งและออกใบกำกับภาษี']
                });
                dropDownControllersimageAddress.add(FormFieldController<String>(
                    'รูปภาพ ${widget.entryMap!['value']['รูปร้านค้า'].indexOf(widget.entryMap!['value']['ListCustomerAddress'][i]['Image']) + 1}'));
                // phoneList!.add(PhoneNumber(
                //     isoCode: 'TH',
                //     dialCode: widget.entryMap!['value']['ListCustomerAddress']
                //                 [i]['หัวข้อโทรศัพท์'] ==
                //             null
                //         ? ''
                //         : widget.entryMap!['value']['ListCustomerAddress'][i]
                //             ['หัวข้อโทรศัพท์'],
                //     phoneNumber: '+66' +
                //         widget.entryMap!['value']['ListCustomerAddress'][i]
                //             ['โทรศัพท์']));

                print('7');

                if (widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['โทรศัพท์'] ==
                    '') {
                  phoneList!.add(PhoneNumber(isoCode: 'TH'));
                } else {
                  if (widget
                          .entryMap!['value']['ListCustomerAddress'][i]
                              ['โทรศัพท์']
                          .length <
                      10) {
                    phoneList!.add(PhoneNumber(isoCode: 'TH'));
                  } else {
                    phoneList!.add(
                        await PhoneNumber.getRegionInfoFromPhoneNumber(
                            widget.entryMap!['value']['ListCustomerAddress'][i]
                                ['โทรศัพท์'],
                            'TH'));
                  }
                }

                textFieldControllerPhoneAddress!.add(TextEditingController(
                    text: widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['โทรศัพท์']));
              }
            }
          } else {
            resultList.add({
              'ID': widget.entryMap!['value']['ListCustomerAddress'][i]
                  ['ID'], //new
              'รหัสสาขา': widget.entryMap!['value']['ListCustomerAddress'][i]
                  ['รหัสสาขา'], //new
              'ชื่อสาขา': widget.entryMap!['value']['ListCustomerAddress'][i]
                  ['ชื่อสาขา'], //new
              'HouseNumber': widget.entryMap!['value']['ListCustomerAddress'][i]
                  ['HouseNumber'],

              'Moo': widget.entryMap!['value']['ListCustomerAddress'][i]
                          ['Moo'] ==
                      null
                  ? ''
                  : widget.entryMap!['value']['ListCustomerAddress'][i]['Moo'],

              'VillageName': widget.entryMap!['value']['ListCustomerAddress'][i]
                  ['VillageName'],
              'Road': widget.entryMap!['value']['ListCustomerAddress'][i]
                  ['Road'], //new
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
              // 'Image': '',
              'Image': '',
              'ผู้ติดต่อ': widget.entryMap!['value']['ListCustomerAddress'][i]
                  ['ผู้ติดต่อ'], //new
              'ตำแหน่ง': widget.entryMap!['value']['ListCustomerAddress'][i]
                  ['ตำแหน่ง'], //new

              'หัวข้อโทรศัพท์': widget.entryMap!['value']['ListCustomerAddress']
                          [i]['หัวข้อโทรศัพท์'] ==
                      null
                  ? ''
                  : widget.entryMap!['value']['ListCustomerAddress'][i]
                      ['หัวข้อโทรศัพท์'], //new
              'โทรศัพท์': widget.entryMap!['value']['ListCustomerAddress'][i]
                  ['โทรศัพท์'], //new

              'ตารางราคา': widget.entryMap!['value']['ListCustomerAddress'][i]
                  ['ตารางราคา'],
              'ที่อยู่จัดส่งและออกใบกำกับภาษี': widget.entryMap!['value']
                  ['ListCustomerAddress'][i]['ที่อยู่จัดส่งและออกใบกำกับภาษี']
            });
            dropDownControllersimageAddress
                .add(FormFieldController<String>(''));
            // phoneList!.add(PhoneNumber(
            //     isoCode: 'TH',
            //     dialCode: widget.entryMap!['value']['ListCustomerAddress'][i]
            //                 ['หัวข้อโทรศัพท์'] ==
            //             null
            //         ? ''
            //         : widget.entryMap!['value']['ListCustomerAddress'][i]
            //             ['หัวข้อโทรศัพท์'],
            //     phoneNumber: '+66' +
            //         widget.entryMap!['value']['ListCustomerAddress'][i]
            //             ['โทรศัพท์']));

            print('8');
            print(widget.entryMap!['value']['ListCustomerAddress'][i]
                ['โทรศัพท์']);

            if (widget.entryMap!['value']['ListCustomerAddress'][i]
                    ['โทรศัพท์'] ==
                '') {
              phoneList!.add(PhoneNumber(isoCode: 'TH'));
              print('111');
            } else {
              if (widget
                      .entryMap!['value']['ListCustomerAddress'][i]['โทรศัพท์']
                      .length <
                  10) {
                phoneList!.add(PhoneNumber(isoCode: 'TH'));
                print('222');
              } else {
                print('333');
                phoneList!.add(await PhoneNumber.getRegionInfoFromPhoneNumber(
                    widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['โทรศัพท์'],
                    'TH'));
                print('333');
              }
            }

            if (widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['โทรศัพท์'] ==
                    '' ||
                widget.entryMap!['value']['ListCustomerAddress'][i]
                        ['โทรศัพท์'] ==
                    null) {
              textFieldControllerPhoneAddress!.add(TextEditingController());
            } else {
              textFieldControllerPhoneAddress!.add(TextEditingController(
                  text: widget.entryMap!['value']['ListCustomerAddress'][i]
                      ['โทรศัพท์']));
            }
            print('9');
          }

          List<dynamic>? childs;
          if (resultList[i]['Province'] == '') {
            amphures!.add([]);
          } else {
            Map<String, dynamic> parentAmphure = provinces!.firstWhere(
                (item) => item['name_th'] == resultList[i]['Province']);
            childs = parentAmphure['amphure'];
            amphures!.add(childs!);
          }
          if (resultList[i]['District'] == '') {
            tambons!.add([]);
          } else {
            Map<String, dynamic> parentTambon = childs!.firstWhere(
                (item) => item['name_th'] == resultList[i]['District']);

            List<dynamic> childsTambon = parentTambon['tambon'];
            tambons!.add(childsTambon);
          }
          print('10');

          //================= find Province =====================================
          Map<String, dynamic>? foundMapProvince;

          if (resultList[i]['Province'] == '') {
            addressProvincesStringControllerType!.add(TextEditingController());
            provincesString.add([]);
          } else {
            for (Map<String, dynamic> map in provinces!) {
              if (map["name_th"] == resultList[i]['Province']) {
                addressProvincesStringControllerType!.add(TextEditingController(
                    text: '${map['name_th']} - ${map['name_en']}'));

                provincesString.add([]);

                print(addressProvincesStringControllerType);
                print(addressProvincesStringControllerType!.length);
                print(addressProvincesStringControllerType!.length);
                print(addressProvincesStringControllerType!.length);
                print(addressProvincesStringControllerType!.length);
                print(addressProvincesStringControllerType!.length);

                foundMapProvince = map;
                break;
              }
            }
          }
          print('11');

          // if (foundMapProvince != null) {
          //   print(
          //       "พบ Map ที่มี id เท่ากับ ${resultList[i]['Province']}: $foundMapProvince");
          //   // resultList[index]['Province'] = foundMapProvince['name_th'];
          // } else {
          //   print("ไม่พบ Map ที่มี id เท่ากับ ${resultList[i]['Province']}");
          // }
          //================= find Amphor =====================================
          Map<String, dynamic>? foundMapAmphor;
          for (List<dynamic> innerList in amphures ?? []) {
            for (Map<String, dynamic> map
                in innerList.cast<Map<String, dynamic>>()) {
              if (map["name_th"] == resultList[i]['District']) {
                foundMapAmphor = map;
                break;
              }
            }
            if (foundMapAmphor != null) {
              break;
            }
          }

          print('12');

          // if (foundMapAmphor != null) {
          //   print(
          //       "พบ Map ที่มี id เท่ากับ ${resultList[i]['District']}: $foundMapAmphor");
          //   // resultList[index]['District'] = foundMapAmphor['name_th'];
          // } else {
          //   print("ไม่พบ Map ที่มี id เท่ากับ ${resultList[i]['District']}");
          // }
          //================= find Tambon =====================================

          Map<String, dynamic>? foundMap;
          for (List<dynamic> innerList in tambons ?? []) {
            for (Map<String, dynamic> map
                in innerList.cast<Map<String, dynamic>>()) {
              if (map["name_th"] == resultList[i]['SubDistrict']) {
                foundMap = map;
                break;
              }
            }
            if (foundMap != null) {
              break;
            }
          }

          print('13');

          // if (foundMap != null) {
          //   print(
          //       "พบ Map ที่มี id เท่ากับ ${resultList[i]['SubDistrict']}: $foundMap");
          // } else {
          //   print("ไม่พบ Map ที่มี id เท่ากับ ${resultList[i]['SubDistrict']}");
          // }
          //================= find Tambon =====================================
          selected.add({
            'province_id':
                resultList[i]['Province'] == '' ? '' : foundMapProvince!['id'],
            'amphure_id':
                resultList[i]['District'] == '' ? '' : foundMapAmphor!['id'],
            'tambon_id':
                resultList[i]['SubDistrict'] == '' ? '' : foundMap!['id'],
          });
          print('14');

          //================= find Tambon =====================================

          postalCodeController!.add(TextEditingController(
              text: widget.entryMap!['value']['ListCustomerAddress'][i]
                  ['PostalCode']));
          //===================================================================
          print('15');

          textFieldFocusSaka!.add(FocusNode());
          textFieldFocusNameSaka!.add(FocusNode());
          textFieldFocusRoad!.add(FocusNode());
          textFieldFocusNameContract!.add(FocusNode());
          textFieldFocusType!.add(FocusNode());

          textFieldFocusPhone!.add(FocusNode());
          textFieldFocusHouseNumber!.add(FocusNode());
          textFieldFocusHouseMoo!.add(FocusNode());

          textFieldFocusVillageName!.add(FocusNode());
          textFieldFocusPostalCode!.add(FocusNode());
          textFieldFocusLatitude!.add(FocusNode());
          textFieldFocusLongitude!.add(FocusNode());

          // dropDownValueControllerProvince.add(FormFieldController<String>(''));
          // dropDownValueControllerDistrict.add(FormFieldController<String>(''));
          // dropDownValueControllerSubDistrict.add(FormFieldController<String>(''));
          print('16');

          List<dynamic> dynamicList = widget.entryMap!['value']
                  ['ListCustomerAddress'][i]['รูปภาพร้าน'] ??
              [];
          List<String> stringList =
              dynamicList.map((item) => item.toString()).toList();

          imageAddressNetwork!.add(stringList);

          List<File?> a = [];
          List<Uint8List?> b = [];

          for (var element in stringList) {
            a.add(null);
            b.add(null);
          }

          imageAddressList!.add(a);
          imageAddressUint8List!.add(b);

          print('+++++++');
          print('+++++++');
          print('+++++++');
          print('+++++++');
          print(imageAddressList);
          print(imageAddressUint8List);

          dropDownControllersPriceTable.add(FormFieldController(widget
              .entryMap!['value']['ListCustomerAddress'][i]['ตารางราคา']));

          dropDownControllersBillTax.add(FormFieldController(
              widget.entryMap!['value']['ListCustomerAddress'][i]
                  ['ที่อยู่จัดส่งและออกใบกำกับภาษี']));

          latList!.add(TextEditingController(text: resultList[i]['Latitude']));
          lotList!.add(TextEditingController(text: resultList[i]['Longitude']));
          print('Success');
        }

        total3 = resultList.length;
      }
      print(dropDownControllersPriceTable);
      print(phoneList);

      categoryProduct = categoryProductController.categoryProductsData;

      categoryProduct!.forEach((key, value) {
        categoryNameList.add(value['GROUP_DESC']);
      });

      // for (int i = 0; i < categoryProduct!.length; i++) {
      //   // print(categoryProduct);
      //   categoryNameList.add(categoryProduct!['key${i}']['GROUP_DESC']);
      // }

      //================ อ่านค่า สินค้าที่จำหน่ายในปัจจุบัน ==================
      for (int i = 0;
          i < widget.entryMap!['value']['CategoryProductNow'].length;
          i++) {
        productType!.add(TextEditingController(
            text: widget.entryMap!['value']['CategoryProductNow'][i]));
        textFieldFocusProductType!.add(FocusNode());
        // if (widget.entryMap!['value']['CategoryProductNow'][i] == null ||
        //     widget.entryMap!['value']['CategoryProductNow'][i] == '') {
        // } else {
        //   dropDownControllers.add(FormFieldController<String>(
        //       widget.entryMap!['value']['CategoryProductNow'][i]));
        //   dropDownValues
        //       .add(widget.entryMap!['value']['CategoryProductNow'][i]);
        // }
      }
      total = widget.entryMap!['value']['CategoryProductNow'].length;
      //=========================================================

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

      // _model.dropDownValueController10 ??= FormFieldController<String>(
      //     widget.entryMap!['value']['ระยะเวลาชำระหนี้']);
      // _model.dropDownValue10 =
      //     widget.entryMap!['value']['ระยะเวลาชำระหนี้'] ?? '';

      _model.textController191 ??= TextEditingController(
          text: widget.entryMap!['value']['ระยะเวลาชำระหนี้']);
      _model.textFieldFocusNode191 ??= FocusNode();

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
      _model.dropDownValueController182 ??= FormFieldController<String>(
          widget.entryMap!['value']['รหัสกลุ่มลูกค้า2']);
      _model.dropDownValueController183 ??= FormFieldController<String>(
          widget.entryMap!['value']['รหัสกลุ่มลูกค้า3']);
      _model.dropDownValueController184 ??= FormFieldController<String>(
          widget.entryMap!['value']['รหัสกลุ่มลูกค้า4']);
      _model.dropDownValueController185 ??= FormFieldController<String>(
          widget.entryMap!['value']['รหัสกลุ่มลูกค้า5']);
      _model.dropDownValue18 =
          widget.entryMap!['value']['รหัสกลุ่มลูกค้า'] ?? '';
      _model.dropDownValue182 =
          widget.entryMap!['value']['รหัสกลุ่มลูกค้า2'] ?? '';
      _model.dropDownValue183 =
          widget.entryMap!['value']['รหัสกลุ่มลูกค้า3'] ?? '';
      _model.dropDownValue184 =
          widget.entryMap!['value']['รหัสกลุ่มลูกค้า4'] ?? '';
      _model.dropDownValue185 =
          widget.entryMap!['value']['รหัสกลุ่มลูกค้า5'] ?? '';

      _model.dropDownValueController19 ??=
          FormFieldController<String>(widget.entryMap!['value']['รหัสบัญชี2']);
      _model.dropDownValue19 = widget.entryMap!['value']['รหัสบัญชี2'] ?? '';
      //=====================================================================
      _model.radioButtonValueController ??=
          FormFieldController<String>(widget.entryMap!['value']['คำนำหน้า']);
      //=====================================================================
      //=====================================================================
      _model.radioButtonValueControllerVat ??=
          FormFieldController<String>(widget.entryMap!['value']['vat']);
      //=====================================================================
      _model.textController1 ??=
          TextEditingController(text: widget.entryMap!['value']['ชื่อนามสกุล']);
      _model.textFieldFocusNode1 ??= FocusNode();

      _model.textControllerName ??= TextEditingController(
          text: widget.entryMap!['value']['ชื่อ'] == '' ||
                  widget.entryMap!['value']['ชื่อ'] == null
              ? ''
              : widget.entryMap!['value']['ชื่อ']);

      _model.textFieldFocusNodeName ??= FocusNode();

      _model.textControllerSurname ??= TextEditingController(
          text: widget.entryMap!['value']['นามสกุล'] == '' ||
                  widget.entryMap!['value']['นามสกุล'] == null
              ? ''
              : widget.entryMap!['value']['นามสกุล']);
      _model.textFieldFocusNodeSurname ??= FocusNode();

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

      //=================================================================
      print('123');
      if (widget.entryMap!['value']['PhoneTypeCountry'] == null ||
          widget.entryMap!['value']['PhoneTypeCountry'] == '') {
        number = PhoneNumber(isoCode: 'TH');
      } else {
        if (widget.entryMap!['value']['PhoneNumber'] == null ||
            widget.entryMap!['value']['PhoneNumber'] == '') {
          number = PhoneNumber(isoCode: 'TH');
        } else {
          number = await PhoneNumber.getRegionInfoFromPhoneNumber(
              '${widget.entryMap!['value']['PhoneTypeCountry']}${widget.entryMap!['value']['PhoneNumber']}',
              'TH');
        }
      }
      print('321');

      //=================================================================

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

      _model.textController12 ??= TextEditingController(
          text: widget.entryMap!['value']['ระยะเวลาการดำเนินการปี']);
      _model.textController121 ??= TextEditingController(
          text: widget.entryMap!['value']['ระยะเวลาการดำเนินการเดือน']);

      _model.textFieldFocusNode12 ??= FocusNode();

      // _model.textController13 ??= TextEditingController(
      //     text: widget.entryMap!['value']['เดือนสิ้นสุด']);
      // _model.textFieldFocusNode13 ??= FocusNode();

      // _model.textController14 ??=
      //     TextEditingController(text: widget.entryMap!['value']['ปีสิ้นสุด']);
      // _model.textFieldFocusNode14 ??= FocusNode();

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

      if (widget.type == 'Company') {
        if (_model.textController41Company.text.length == 13) {
          FirebaseFirestore firestore = FirebaseFirestore.instance;

          QuerySnapshot querySnapshot = await firestore
              .collection(AppSettings.customerType == CustomerType.Test
                  ? 'CustomerTest'
                  : 'Customer')
              .where('เลขประจำตัวผู้เสียภาษี',
                  isEqualTo: _model.textController5.text)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            querySnapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              var fieldValue = data['สถานะ'];
              var fieldValue2 = data['รอการอนุมัติ'];
              var fieldValue3 = data['บันทึกพร้อมตรวจ'];

              if (!fieldValue && !fieldValue2 && !fieldValue3) {
                checkID = 'orange';
                setState(() {});
              } else {
                checkID = 'red';
                setState(() {});
              }
            });
          } else {
            print('ไม่พบเอกสารที่ตรงกับเงื่อนไข');
            checkID = 'green';
            setState(() {});
          }
        }
      } else {
        if (_model.textController5.text.length == 13) {
          FirebaseFirestore firestore = FirebaseFirestore.instance;

          QuerySnapshot querySnapshot = await firestore
              .collection(AppSettings.customerType == CustomerType.Test
                  ? 'CustomerTest'
                  : 'Customer')
              .where('เลขบัตรประชาชน', isEqualTo: _model.textController5.text)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            querySnapshot.docs.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              var fieldValue = data['สถานะ'];
              var fieldValue2 = data['รอการอนุมัติ'];
              var fieldValue3 = data['บันทึกพร้อมตรวจ'];

              if (!fieldValue && !fieldValue2 && !fieldValue3) {
                checkID = 'orange';
                // setState(() {});
              } else {
                checkID = 'red';
                // setState(() {});
              }
            });
          } else {
            print('ไม่พบเอกสารที่ตรงกับเงื่อนไข');
            checkID = 'green';
            // setState(() {});
          }
        } else {
          checkID = 'green';
          // setState(() {});
        }
      }

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

          if (resultListSendAndBill[i]['ที่อยู่จัดส่ง'] == '') {
            dropDownControllersSend.add(FormFieldController<String>(''));
            dropDownControllersSend.last.value = '';
          } else {
            dropDownControllersSend.add(FormFieldController<String>(
                resultListSendAndBill[i]['ที่อยู่จัดส่ง']));
          }

          if (resultListSendAndBill[i]['ที่อยู่ออกบิล'] == '') {
            dropDownControllersBill.add(FormFieldController<String>(''));
            dropDownControllersBill.last.value = '';
          } else {
            dropDownControllersBill.add(FormFieldController<String>(
                resultListSendAndBill[i]['ที่อยู่ออกบิล']));
          }

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
      print('รูปร้านค้า');
      //================================================================

      for (int i = 0; i < widget.entryMap!['value']['รูปเอกสาร'].length; i++) {
        for (int j = 0;
            j < widget.entryMap!['value']['รูปเอกสาร'][i]['key'].length;
            j++) {
          imageUrlFromFirestoreList2![i]!
              .add(widget.entryMap!['value']['รูปเอกสาร'][i]['key'][j]);

          imageFileList2![i]!.add(null);
          imageList2![i]!.add(null);
          imageUint8ListList2![i]!.add(null);
        }
      }

      // for (var element in widget.entryMap!['value']['รูปเอกสาร']) {
      //   // imageUrlFromFirestore2.add(element);
      //   // imageUrlForDelete2.add(element);
      //   // imageUrl2.add(element);
      //   // imageFile2.add(null);
      //   // image2!.add(File(''));
      //   // imageUint8List2.add(Uint8List(0));
      // }

      imageLength2 = imageUrlFromFirestoreList2![0]!.length +
          imageUrlFromFirestoreList2![1]!.length +
          imageUrlFromFirestoreList2![2]!.length +
          imageUrlFromFirestoreList2![3]!.length +
          imageUrlFromFirestoreList2![4]!.length;
      //===========================   file pdf url =====================================

      for (int i = 0; i < widget.entryMap!['value']['ไฟล์เอกสาร'].length; i++) {
        for (int j = 0;
            j < widget.entryMap!['value']['ไฟล์เอกสาร'][i]['key'].length;
            j++) {
          fileUrlFromFirestoreList![i]!
              .add(widget.entryMap!['value']['ไฟล์เอกสาร'][i]['key'][j]);

          finalFileResultString![i]!.add('');
        }
      }

      //================================================================

      // imageLength2 = widget.entryMap!['value']['รูปเอกสาร'].length;
      // for (var element in widget.entryMap!['value']['รูปเอกสาร']) {
      //   imageUrlFromFirestore2.add(element);
      //   imageUrlForDelete2.add(element);
      //   imageUrl2.add(element);
      //   imageFile2.add(null);
      //   image2!.add(File(''));
      //   imageUint8List2.add(Uint8List(0));
      // }
      //================================================================
      print('load Data to Map');
      late double lat;
      late double lot;

      if (resultList[0]['Latitude'] == '' || resultList[0]['Longitude'] == '') {
        for (int i = 0; i < resultList.length; i++) {
          if (resultList[i]['Latitude'] != '' &&
              resultList[i]['Longitude'] != '') {
            lat = double.parse(resultList[i]['Latitude']);
            lot = double.parse(resultList[i]['Longitude']);
            break;
          } else {
            lat = 13.7563309;
            lot = 100.5017651;
          }
        }
      } else {
        lat = double.parse(resultList[0]['Latitude']);
        lot = double.parse(resultList[0]['Longitude']);
      }

      //=====================================================

      // _kGooglePlex = CameraPosition(
      //   target: google_maps.LatLng(lat, lot),
      //   zoom: 15,
      // );

      // markers.clear();

      // for (int i = 0; i < resultList.length; i++) {
      //   if (resultList[i]['Latitude'] == '') {
      //   } else {
      //     double latIndex = double.parse(resultList[i]['Latitude']);
      //     double lotIndex = double.parse(resultList[i]['Longitude']!);

      //     markers.add(
      //       Marker(
      //         markerId: MarkerId(resultList[i]['ID']),
      //         position: google_maps.LatLng(latIndex, lotIndex), // ตำแหน่ง
      //         infoWindow: InfoWindow(
      //           title: 'จุดที่ ${i + 1}', // ชื่อของปักหมุด
      //           snippet: resultList[i]['Latitude'],
      //           onTap: () async {
      //             await mapDialog(resultList, resultList[i]['ID'])
      //                 .whenComplete(() {
      //               _mapKey = GlobalKey();
      //               if (mounted) {
      //                 setState(() {});
      //               }
      //             });
      //           }, // คำอธิบายของปักหมุด
      //         ),
      //       ),
      //     );
      //   }
      // }

      //=====================================================

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
              (element) => element['name_th'] == resultList[i]['Province'],
              orElse: () => {});

          provincesName = resultProvince['name_th'] ?? '';
        }
        //====================================================================
        if (resultList[i]['District'] == '' ||
            resultList[i]['District'] == null) {
          amphorName = '';
        } else {
          Map<String, dynamic> resultAmphure = mapList.firstWhere(
              (element) => element['name_th'] == resultList[i]['District'],
              orElse: () => {});

          amphorName = resultAmphure['name_th'] ?? '';
        }

        //====================================================================
        if (resultList[i]['SubDistrict'] == '' ||
            resultList[i]['SubDistrict'] == null) {
          tambonName = '';
        } else {
          Map<String, dynamic> resultTambon = tambonList.firstWhere(
              (element) => element['name_th'] == resultList[i]['SubDistrict'],
              orElse: () => {});
          tambonName = resultTambon['name_th'] ?? '';
        }
        //====================================================================
        addressThai.add({
          'province_name': provincesName! == '' ? provincesName : provincesName,
          'amphure_name': amphorName! == '' ? amphorName : amphorName,
          'tambon_name': tambonName! == '' ? tambonName : tambonName,
        });

        String texttt =
            '${resultList[i]['รหัสสาขา']} ${resultList[i]['ชื่อสาขา']} ${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${resultList[i]['Road']} ${resultList[i]['SubDistrict']} ${resultList[i]['District']} ${resultList[i]['Province']} ${resultList[i]['PostalCode']} ${resultList[i]['ผู้ติดต่อ']} ${resultList[i]['ตำแหน่ง']} ${resultList[i]['โทรศัพท์']}';

        addressAllForDropdown.add(texttt.trimLeft().trimRight());

        addressAllForDropdownForCheckIndex.add(texttt.trimLeft().trimRight());
      }

      if (checkIDforAddress) {
        houseNumber.text = homeAddress.text;
        moo.text = mooAddress.text;
        nameMoo.text = nameMooAddress.text;
        raod.text = roadAddress.text;
        province.text = proviceAddress.text;
        district.text = districAddressController.text;
        subDistrict.text = subDistricAddressController.text;
        postalCodeController![0].text = codeAddress.text;
      } else {
        print(resultList[0]['HouseNumber']);
        houseNumber.text = resultList[0]['HouseNumber'];
        moo.text = resultList[0]['Moo'];
        nameMoo.text = resultList[0]['VillageName'];
        raod.text = resultList[0]['Road'];
        // province.text = resultList[0]['Province'];
        // district.text = resultList[0]['District'];
        // subDistrict.text = resultList[0]['SubDistrict'];
        postalCodeController![0].text = resultList[0]['PostalCode'];
      }
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

  Widget dropdownTambon({
    List<dynamic>? list,
  }) {
    return StatefulBuilder(builder: (context, setState) {
      void onChangeHandle(String? selectedValue) {
        // // print('IN onChangeHandle()');
        // // print(selectedValue);

        if (selectedValue!.isEmpty) return;

        int? dependId =
            selectedValue.isNotEmpty ? int.parse(selectedValue) : null;

        // print(dependId.toString());
        // print(dependId.toString());
        // print(dependId.toString());

        Map<String, dynamic> parent =
            list!.firstWhere((item) => item['id'] == dependId);

        subDistricAddressController.text =
            '${parent['name_th']} - ${parent['name_en']}';

        codeAddress.text = parent['zip_code'].toString();

        // print(subDistricAddressController.text);
        // print(subDistricAddressController.text);
        // print(subDistricAddressController.text);
        // print(subDistricAddressController.text);
        // print(subDistricAddressController.text);
        // print(subDistricAddressController.text);

        // print(childs);

        // print('+++++++++++++++++++++');
        // print('+++++++++++++++++++++');

        subDistricAddress = selectedValue;

        checkIDforAddress = false;

        toSetState();

        // print(subDistricAddress);
        // print(subDistricAddress);
        // print('+++++++++++++++++++++');
        // print('+++++++++++++++++++++');
      }

      // print('+++++++++++++++++++++');
      // print(list);
      // print('+++++++++++++++++++++');

      // amphuresListFirst!.clear();
      // list!.forEach((element) {
      //   String text = '${element['name_th']} - ${element['name_en']}';

      //   amphuresListFirst!.add(text);
      // });
      // print('====== 000000 ======');
      // print(amphuresListFirst);
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
                    'ตำบล',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  underline: Container(),
                  elevation: 2,

                  value: subDistricAddress,
                  onChanged: onChangeHandle,
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(
                        'ตำบล',
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

  Widget dropdownAmphor({
    List<dynamic>? list,
    String? child,
  }) {
    return StatefulBuilder(builder: (context, setState) {
      void onChangeHandle(String? selectedValue) {
        // // print('IN onChangeHandle()');
        // // print(selectedValue);

        if (selectedValue!.isEmpty) return;

        int? dependId =
            selectedValue.isNotEmpty ? int.parse(selectedValue) : null;

        // print(dependId.toString());
        // print(dependId.toString());
        // print(dependId.toString());

        Map<String, dynamic> parent =
            list!.firstWhere((item) => item['id'] == dependId);

        districAddressController.text =
            '${parent['name_th']} - ${parent['name_en']}';

        // print(districAddressController.text);
        // print(districAddressController.text);
        // print(districAddressController.text);
        // print(districAddressController.text);
        // print(districAddressController.text);
        // print(districAddressController.text);

        List<dynamic> childs = parent[child];

        // print(childs);

        tambonsListFirst = childs;
        // print('+++++++++++++++++++++');
        // print('+++++++++++++++++++++');

        subDistricAddressController!.clear();
        subDistricAddress = null;
        codeAddress.text = '';

        districAddress = selectedValue;
        checkIDforAddress = false;

        toSetState();

        // print(districAddress);
        // print(districAddress);
        // print('+++++++++++++++++++++');
        // print('+++++++++++++++++++++');
      }

      // print('+++++++++++++++++++++');
      // print(list);
      // print('+++++++++++++++++++++');

      // amphuresListFirst!.clear();
      // list!.forEach((element) {
      //   String text = '${element['name_th']} - ${element['name_en']}';

      //   amphuresListFirst!.add(text);
      // });
      // print('====== 000000 ======');
      // print(amphuresListFirst);
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
                    'อำเภอ',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  underline: Container(),
                  elevation: 2,

                  value: districAddress,
                  onChanged: onChangeHandle,
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(
                        'อำเภอ',
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

  Widget dropdownProvince({
    List<dynamic>? list,
    String? child,
  }) {
    return StatefulBuilder(builder: (context, setStateIn) {
      void onChangeHandle(String? selectedValue) {
        // print('IN onChangeHandle()');
        // print(selectedValue);

        if (selectedValue!.isEmpty) return;

        int? dependId =
            selectedValue.isNotEmpty ? int.parse(selectedValue) : null;

        print(dependId.toString());
        print(dependId.toString());
        print(dependId.toString());

        print(proviceAddress.text);
        print(proviceAddress.text);
        print(proviceAddress.text);
        print(proviceAddress.text);
        print(proviceAddress.text);
        print(proviceAddress.text);

        Map<String, dynamic> parent =
            list!.firstWhere((item) => item['id'] == dependId);
        List<dynamic> childs = parent[child];

        print(childs);

        amphuresListFirst = childs;
        checkIDforAddress = false;

        toSetState();
      }

      provincesListFirst.clear();

      list!.forEach((element) {
        String text = '${element['name_th']} - ${element['name_en']}';

        provincesListFirst.add(text);
      });

      proviceAddress!.addListener(() {
        // ทำงานที่คุณต้องการเมื่อมีการเปลี่ยนแปลงใน text controller
        // print(
        //     'Text changed: ${addressProvincesStringControllerType![index].text}');

        String nameThOnly = proviceAddress.text.split(' - ')[0];

        var item =
            list!.firstWhere((element) => element['name_th'] == nameThOnly);

        selectedFirst[id!] = item['id'];

        districAddressController!.clear();
        subDistricAddressController!.clear();

        districAddress = null;
        subDistricAddress = null;
        codeAddress.text = '';

        onChangeHandle(selectedFirst[id!].toString());
        // scrollUp();
        // setState(() {});

        // ทำสิ่งที่คุณต้องการทำ
        // ...
      });

      return Row(
        children: [
          Expanded(
            child: Container(
              // height: 55.0,
              // decoration: BoxDecoration(
              //   border: Border.all(
              //       color: FlutterFlowTheme.of(context).alternate, width: 2),
              //   borderRadius: BorderRadius.circular(8.0),
              // ),
              child: Container(
                // color: Colors.red,
                // margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),

                decoration: BoxDecoration(
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),

                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, right: 15),
                  child: DropdownCustom(
                    // suffixIcon: Icons.arrow_left_outlined,
                    textController: proviceAddress!,

                    items: provincesListFirst,

                    dropdownHeight: 400,
                    textFieldBorder: InputBorder.none, // ไม่มีเส้นขอบ
                    hintText: 'ค้นหาจังหวัด',
                    hintStyle: FlutterFlowTheme.of(context).labelMedium,
                    // style: FlutterFlowTheme.of(context).labelMedium,
                    // dropdownBgColor: Colors.white,
                    // contentPadding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget dropdownList2({
    String? label,
    String? id,
    List<dynamic>? list,
    String? child,
    List<String>? childsId,
    List<Function(List<dynamic>?, int)>? setChilds,
    int? index,
  }) {
    return StatefulBuilder(builder: (context, setState) {
      print(index);
      print('select dropdown index');
      print('select dropdown index');
      print('select dropdown index');
      print('select dropdown index');
      print('select dropdown index');
      print('select dropdown index');
      print('select dropdown index');

      print(selected[index!]);

      void onChangeHandle(String? selectedValue) {
        print('IN onChangeHandle()');
        print(selectedValue);

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

        //================= find Province =====================================
        print('province');
        Map<String, dynamic>? foundMapProvince;
        // print(selected[index!]['province_id']);
        // print(provinces);

        for (Map<String, dynamic> map in provinces!) {
          // print(map);
          if (map["id"] == selected[index!]['province_id']) {
            foundMapProvince = map;
            break;
          }
        }

        if (foundMapProvince != null) {
          print(
              "พบ Map ที่มี id เท่ากับ ${selected[index!]['province_id']}: $foundMapProvince");
          // resultList[index]['Province'] = foundMapProvince['name_th'];
          resultList[index]['Province'] = foundMapProvince!['name_th'];
        } else {
          print(
              "ไม่พบ Map ที่มี id เท่ากับ ${selected[index!]['province_id']}");
        }
        print('province');
        //================= find Amphor =====================================
        print('amphor');
        Map<String, dynamic>? foundMapAmphor;
        for (List<dynamic> innerList in amphures ?? []) {
          for (Map<String, dynamic> map
              in innerList.cast<Map<String, dynamic>>()) {
            if (map["id"] == selected[index]['amphure_id']) {
              foundMapAmphor = map;
              break;
            }
          }
          if (foundMapAmphor != null) {
            break;
          }
        }
        if (foundMapAmphor != null) {
          print(
              "พบ Map ที่มี id เท่ากับ ${selected[index]['amphure_id']}: $foundMapAmphor");
          // resultList[index]['District'] = foundMapAmphor['name_th'];
          resultList[index]['District'] = foundMapAmphor!['name_th'];
        } else {
          print("ไม่พบ Map ที่มี id เท่ากับ ${selected[index]['amphure_id']}");
          print('amphor');
          resultList[index]['District'] = '';
        }
        //================= find Tambon =====================================
        print('tambon');

        Map<String, dynamic>? foundMap;
        for (List<dynamic> innerList in tambons ?? []) {
          for (Map<String, dynamic> map
              in innerList.cast<Map<String, dynamic>>()) {
            if (map["id"] == selected[index]['tambon_id']) {
              foundMap = map;
              break;
            }
          }
          if (foundMap != null) {
            break;
          }
        }
        if (foundMap != null) {
          print(
              "พบ Map ที่มี id เท่ากับ ${selected[index]['tambon_id']}: $foundMap");
          print(foundMap['zip_code']);
          resultList[index]['PostalCode'] = foundMap['zip_code'].toString();
          resultList[index]['SubDistrict'] = foundMap!['name_th'];
          // resultList[index]['SubDistrict'] = foundMap['name_th'];

          postalCodeController![index].text = foundMap['zip_code'].toString();
        } else {
          print("ไม่พบ Map ที่มี id เท่ากับ ${selected[index]['tambon_id']}");

          postalCodeController![index].text = '';
          resultList[index]['PostalCode'] = '';
          resultList[index]['SubDistrict'] = '';
        }

        // print('tambon');

        // label == 'Province: '
        //     ? resultList[index]['Province'] = foundMapProvince!['name_th']
        //     : label == 'District: '
        //         ? resultList[index]['District'] = foundMapAmphor!['name_th']
        //         : resultList[index]['SubDistrict'] = foundMap!['name_th'];

        refreshAddressForDropdown(setState, index);

        toSetState();
      }

      List<String> data = [];

      // provincesString[index]=[];
      // amphuresString[index]=[];
      // tambonsString[index]=[];

      label == 'Province: '
          ? provincesString[index] = []
          : label == 'District: '
              ? amphuresString[index] = []
              : tambonsString[index] = [];

      // print('1231231232123');
      // print(label);
      // print(list);

      list!.forEach((element) {
        String text = '${element['name_th']} - ${element['name_en']}';

        label == 'Province: '
            ? provincesString[index].add(text)
            : label == 'District: '
                ? amphuresString[index].add(text)
                : tambonsString[index].add(text);
      });

      // label == 'Province: '
      //     ? print(provincesString)
      //     : label == 'District: '
      //         ? print(amphuresString)
      //         : print(tambonsString);

      // label == 'Province: '
      //     ? print(provincesString[index].length.toString())
      //     : label == 'District: '
      //         ? print(amphuresString[index].length.toString())
      //         : print(tambonsString[index].length.toString());

      label == 'Province: '
          ? addressProvincesStringControllerType![index]!.addListener(() {
              // ทำงานที่คุณต้องการเมื่อมีการเปลี่ยนแปลงใน text controller
              print(
                  'Text changed: ${addressProvincesStringControllerType![index].text}');

              String nameThOnly = addressProvincesStringControllerType![index]
                  .text
                  .split(' - ')[0];

              var item = list!
                  .firstWhere((element) => element['name_th'] == nameThOnly);

              selected[index][id!] = item['id'];

              onChangeHandle(selected[index][id].toString());
              // scrollUp();
              // setState(() {});

              // ทำสิ่งที่คุณต้องการทำ
              // ...
            })
          : label == 'District: '
              ? addressAmphuresStringControllerType![index]!.addListener(() {
                  // ทำงานที่คุณต้องการเมื่อมีการเปลี่ยนแปลงใน text controller
                  print(
                      'Text changed: ${addressAmphuresStringControllerType![index].text}');
                  // ทำสิ่งที่คุณต้องการทำ
                  // ...
                })
              : addressTambonsStringControllerType![index]!.addListener(() {
                  // ทำงานที่คุณต้องการเมื่อมีการเปลี่ยนแปลงใน text controller
                  print(
                      'Text changed: ${addressTambonsStringControllerType![index].text}');
                  // ทำสิ่งที่คุณต้องการทำ
                  // ...
                });
      return Row(
        children: [
          Expanded(
            child: Container(
              // height: 55.0,
              // decoration: BoxDecoration(
              //   border: Border.all(
              //       color: FlutterFlowTheme.of(context).alternate, width: 2),
              //   borderRadius: BorderRadius.circular(8.0),
              // ),
              child: Container(
                // color: Colors.red,
                // margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                // child: Padding(
                //   padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),

                decoration: BoxDecoration(
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),

                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10, right: 15),
                  child: DropdownCustom(
                    // suffixIcon: Icons.arrow_left_outlined,
                    textController:
                        addressProvincesStringControllerType![index],

                    items: provincesString[index],

                    dropdownHeight: 400,
                    textFieldBorder: InputBorder.none, // ไม่มีเส้นขอบ
                    hintText: 'ค้นหาจังหวัด',
                    hintStyle: FlutterFlowTheme.of(context).labelMedium,
                    // style: FlutterFlowTheme.of(context).labelMedium,
                    // dropdownBgColor: Colors.white,
                    // contentPadding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
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

        //================= find Province =====================================
        Map<String, dynamic>? foundMapProvince;

        for (Map<String, dynamic> map in provinces!) {
          if (map["id"] == selected[index!]['province_id']) {
            foundMapProvince = map;
            break;
          }
        }

        if (foundMapProvince != null) {
          print(
              "พบ Map ที่มี id เท่ากับ ${selected[index!]['province_id']}: $foundMapProvince");
          // resultList[index]['Province'] = foundMapProvince['name_th'];
          resultList[index]['Province'] = foundMapProvince!['name_th'];
        } else {
          print(
              "ไม่พบ Map ที่มี id เท่ากับ ${selected[index!]['province_id']}");
        }
        //================= find Amphor =====================================
        Map<String, dynamic>? foundMapAmphor;
        for (List<dynamic> innerList in amphures ?? []) {
          for (Map<String, dynamic> map
              in innerList.cast<Map<String, dynamic>>()) {
            if (map["id"] == selected[index]['amphure_id']) {
              foundMapAmphor = map;
              break;
            }
          }
          if (foundMapAmphor != null) {
            break;
          }
        }
        if (foundMapAmphor != null) {
          print(
              "พบ Map ที่มี id เท่ากับ ${selected[index]['amphure_id']}: $foundMapAmphor");
          // resultList[index]['District'] = foundMapAmphor['name_th'];
          resultList[index]['District'] = foundMapAmphor!['name_th'];
        } else {
          print("ไม่พบ Map ที่มี id เท่ากับ ${selected[index]['amphure_id']}");
          resultList[index]['District'] = '';
        }
        //================= find Tambon =====================================

        Map<String, dynamic>? foundMap;
        for (List<dynamic> innerList in tambons ?? []) {
          for (Map<String, dynamic> map
              in innerList.cast<Map<String, dynamic>>()) {
            if (map["id"] == selected[index]['tambon_id']) {
              foundMap = map;
              break;
            }
          }
          if (foundMap != null) {
            break;
          }
        }
        if (foundMap != null) {
          print(
              "พบ Map ที่มี id เท่ากับ ${selected[index]['tambon_id']}: $foundMap");
          resultList[index]['PostalCode'] = foundMap['zip_code'].toString();
          resultList[index]['SubDistrict'] = foundMap!['name_th'];
          // resultList[index]['SubDistrict'] = foundMap['name_th'];

          postalCodeController![index].text = foundMap['zip_code'].toString();
        } else {
          print("ไม่พบ Map ที่มี id เท่ากับ ${selected[index]['tambon_id']}");

          postalCodeController![index].text = '';
          resultList[index]['PostalCode'] = '';
          resultList[index]['SubDistrict'] = '';
        }

        refreshAddressForDropdown(setState, index);

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

  trySummit(bool checkButtonSuccess, String textCheck) async {
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

      String docID = uuid.v4();

      String signatureUrl = '';
      if (signConfirm == false) {
      } else {
        signatureUrl = await saveSignatureToFirestore(base64ImgSign, docID);
      }

      //================================= List image ที่อยู่ ======================================

      List<List<String>> listUrlNew = [];

      for (int i = 0; i < imageAddressList!.length; i++) {
        listUrlNew.add([]);
      }

      for (int i = 0; i < imageAddressList!.length; i++) {
        for (int j = 0; j < imageAddressList![i]!.length; j++) {
          if (imageAddressList![i]![j] == null) {
            listUrlNew[i].add(imageAddressNetwork![i]![j]!);
          } else {
            String fileName =
                '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg';

            if (imageAddressList![i]![j]!.path.isEmpty) {
              // listUrl.add(imageUrl[i]);
            } else {
              refNew = FirebaseStorage.instance
                  .ref()
                  .child('images')
                  .child('Users')
                  .child(userController.userData!['UserID'])
                  .child(AppSettings.customerType == CustomerType.Test
                      ? 'CustomerTest'
                      : 'Customer')
                  .child(docID)
                  .child(DateTime.now().month.toString())
                  .child('${DateTime.now().day}/$fileName');

              await refNew!.putFile(imageAddressList![i]![j]!).whenComplete(
                () async {
                  await refNew!.getDownloadURL().then(
                    (value2) {
                      listUrlNew[i].add(value2);
                    },
                  );
                },
              );
            }
          }
        }
      }
      for (int i = 0; i < resultList.length; i++) {
        resultList[i]['รูปภาพร้าน'] = listUrlNew[i];
      }

      listBillTaxIndex.clear();

      for (int i = 0; i < dropDownControllersBillTax.length; i++) {
        if (dropDownControllersBillTax[i].value == null) {
          dropDownControllersBillTax[i].value = '';
        }

        // print(dropDownControllersBillTax[i].value!);
        int index = addressAllForDropdownForCheckIndex.indexOf(
            dropDownControllersBillTax[i].value!.trimLeft().trimRight());
        if (index != -1) {
          print('Index found: $index');
          listBillTaxIndex.add(index.toString());
        } else {
          listBillTaxIndex.add('');

          print('Index not found');
        }
      }
      for (int i = 0; i < resultList.length; i++) {
        resultList[i]['indexที่อยู่จัดส่งและออกใบกำกับภาษี'] =
            listBillTaxIndex[i];
      }
      //=====================================================================

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
              .child(AppSettings.customerType == CustomerType.Test
                  ? 'CustomerTest'
                  : 'Customer')
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
      //======================= รูปเอกสาร =======================================
      List<List<String>> listUrlList2 = List.generate(5, (_) => []);

      for (int i = 0; i < imageUrlFromFirestoreList2!.length; i++) {
        for (int j = 0; j < imageUrlFromFirestoreList2![i]!.length; j++) {
          String fileName2 =
              '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg';
          if (imageUrlFromFirestoreList2![i]![j].isNotEmpty ||
              imageUrlFromFirestoreList2![i]![j] != '') {
            listUrlList2[i].add(imageUrlFromFirestoreList2![i]![j]);
          } else {
            ref3 = FirebaseStorage.instance
                .ref()
                .child('images')
                .child('Users')
                .child(userController.userData!['UserID'])
                .child(AppSettings.customerType == CustomerType.Test
                    ? 'CustomerTest'
                    : 'Customer')
                .child(docID)
                .child(DateTime.now().month.toString())
                .child('${DateTime.now().day}/$fileName2');

            await ref3!.putFile(imageList2![i]![j]!).whenComplete(
              () async {
                await ref3!.getDownloadURL().then(
                  (value2) {
                    listUrlList2[i].add(value2);
                  },
                );
              },
            );
          }
        }
      }

      List<Map<String, List<String>>> listOfMaps = listUrlList2.map((list) {
        return {
          'key': list.map((value) => value).toList(),
        };
      }).toList();
      //========================================================================
      //======================= ไฟล์เอกสาร =======================================
      List<List<String>> fileUrl = List.generate(5, (_) => []);

      for (int i = 0; i < fileUrlFromFirestoreList!.length; i++) {
        for (int j = 0; j < fileUrlFromFirestoreList![i]!.length; j++) {
          String fileName2 =
              '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}$finalFileResultString.pdf';
          if (fileUrlFromFirestoreList![i]![j].isNotEmpty ||
              fileUrlFromFirestoreList![i]![j] != '') {
            fileUrl[i].add(fileUrlFromFirestoreList![i]![j]);
          } else {
            ref4 = FirebaseStorage.instance
                .ref()
                .child('files')
                .child('Users')
                .child(userController.userData!['UserID'])
                .child(AppSettings.customerType == CustomerType.Test
                    ? 'CustomerTest'
                    : 'Customer')
                .child(docID)
                .child(DateTime.now().month.toString())
                .child('${DateTime.now().day}/$fileName2');

            await ref4!
                .putFile(File(finalFileResultString![i]![j]))
                .whenComplete(
              () async {
                await ref4!.getDownloadURL().then(
                  (fileUrlValue) {
                    fileUrl[i].add(fileUrlValue);
                  },
                );
              },
            );
          }
        }
      }

      List<Map<String, List<String>>> listFileOfMaps = fileUrl.map((file) {
        return {
          'key': file.map((value) => value).toList(),
        };
      }).toList();

      for (int i = 0; i < sendAndBillList!.length; i++) {
        resultListSendAndBill[i]['ชื่อออกบิล'] = sendAndBillList![i].text;
      }

      for (int i = 0; i < resultList.length; i++) {
        if (resultList[i]['Image'] == '') {
          resultList[i]['Image'] = '';
        } else {
          int indexImage = int.parse(resultList[i]['Image']);
          resultList[i]['Image'] = listUrl[indexImage - 1];
        }
      }

      for (int i = 0; i < productType!.length; i++) {
        productTypeFinal!.add(productType![i].text);
      }

      print(_model.textControllerName.text);

      print(resultList);

      productTypeFinal!.forEach((element) {
        if (!productTypeEmployee.contains(element)) {
          productTypeEmployee.add(element!);
        }
      });

      productTypeEmployee.sort((a, b) {
        String nameA = a;
        String nameB = b;

        return nameA.compareTo(nameB);
      });

      await FirebaseFirestore.instance
          .collection('User')
          .doc(userController.userData!['UserID'])
          .update({'ประเภทสินค้า': productTypeEmployee}).then((value) async {
        final test = FirebaseFirestore.instance
            .collection('User')
            .doc(userController.userData!['UserID'])
            .get();
        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await test;

        await userController.updateUserDataPhone(documentSnapshot);
        // .then((value) => context.push('A011_Home'));
      });

      if (textCheck == 'check') {
        // if(widget.entryMap!['value']['สถานะ'] == false &&
        //           widget.entryMap!['value']['รอการอนุมัติ'] == false &&
        //           widget.entryMap!['value']['บันทึกพร้อมตรวจ'] == false){}else{}
        await FirebaseFirestore.instance
            .collection(AppSettings.customerType == CustomerType.Test
                ? 'CustomerTest'
                : 'Customer')
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
          'vat': _model.radioButtonValueControllerVat == null
              ? ''
              : _model.radioButtonValueControllerVat!.value,

          'ชื่อนามสกุล':
              '${_model.textControllerName.text} ${_model.textControllerSurname.text}',
          'ชื่อ': _model.textControllerName.text,
          'นามสกุล': _model.textControllerSurname.text,
          'วันเกิด': _model.textController2.text,
          'เดือนเกิด': _model.textController3.text,
          'ปีเกิด': _model.textController4.text,
          'เลขบัตรประชาชน': _model.textController5.text,

          'ใช้ที่อยู่ตามบัตร': checkIDforAddress,

          'บ้านเลขที่': homeAddress.text,
          'หมู่': mooAddress.text,
          'หมู่บ้าน': nameMooAddress.text,
          'ถนน': roadAddress.text,
          'จังหวัด': proviceAddress.text,
          'อำเภอ': districAddressController.text,
          'ตำบล': subDistricAddressController.text,
          'รหัสไปรษณีย์': codeAddress.text,

          'PhoneTypeCountry': number.dialCode == null
              ? ''
              : number.dialCode!.startsWith('+')
                  ? number.dialCode ?? ''
                  : '+${number.dialCode ?? ''}',
          'PhoneNumber': _model.textController6.text,
          'วันเริ่มจัดส่ง': _model.textController7.text,
          'เดือนเริ่มจัดส่ง': _model.textController8.text,
          'ปีเริ่มจัดส่ง': _model.textController9.text,
          'ชื่อร้านค้า': _model.textController10.text,
          'เป้าหมายยอดขาย': _model.textController11.text,
          'CategoryProductNow': productTypeFinal,
          'ระยะเวลาการดำเนินการ': _model.textController12.text,
          'ระยะเวลาการดำเนินการปี': _model.textController12.text,
          'ระยะเวลาการดำเนินการเดือน': _model.textController121.text,

          // 'วันสิ้นสุด': _model.textController12.text,
          // 'เดือนสิ้นสุด': _model.textController13.text,
          // 'ปีสิ้นสุด': _model.textController14.text,
          'CategoryProductOrder': dropDownValues2,
          'ListCustomerAddress': resultList,
          'ตารางราคา': _model.dropDownValue6 ?? '',
          // 'ที่อยู่จัดส่ง': _model.dropDownValue7,
          // 'ที่อยู่ออกบิล': _model.dropDownValue8,
          // 'ที่อยู่อื่น': _model.dropDownValue9,

          'ลิสต์จัดส่งและออกบิล': resultListSendAndBill,
          'ระยะเวลาชำระหนี้': _model.textController191.text,
          'วงเงินเครดิต': _model.textController19.text,
          'ส่วนลดบิล': _model.textController20.text,
          'ประเภทชำระ': _model.dropDownValue11 ?? '',
          'เงื่อนไขชำระ': _model.dropDownValue12 ?? '',
          'บัญชีธนาคารของบริษัท': _model.dropDownValue13 ?? '',
          'แผนก': _model.dropDownValue14 ?? '',
          'รหัสบัญชี': _model.dropDownValue15 ?? '',
          'รหัสพนักงานขาย': widget.entryMap!['value']['รหัสพนักงานขาย'],
          'ชื่อพนักงานขาย': widget.entryMap!['value']['ชื่อพนักงานขาย'],
          'รหัสกลุ่มลูกค้า': _model.dropDownValue18 ?? '',
          'รหัสกลุ่มลูกค้า2': _model.dropDownValue182 ?? '',
          'รหัสกลุ่มลูกค้า3': _model.dropDownValue183 ?? '',
          'รหัสกลุ่มลูกค้า4': _model.dropDownValue184 ?? '',
          'รหัสกลุ่มลูกค้า5': _model.dropDownValue185 ?? '',
          'รหัสบัญชี2': _model.dropDownValue19,
          'รูปร้านค้า': listUrl,
          // 'รูปเอกสาร': listUrl2,
          'รูปเอกสาร': listOfMaps,
          'ไฟล์เอกสาร': listFileOfMaps,
          'ลายเซ็น': widget.entryMap!['value']['ลายเซ็น'] != ''
              ? widget.entryMap!['value']['ลายเซ็น']
              : signatureUrl,
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

          'ProjectID': '20231208151700',

          'SectionID': '20231208151899',

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
          // print(number.dialCode);
        });
      } else {
        await FirebaseFirestore.instance
            .collection(AppSettings.customerType == CustomerType.Test
                ? 'CustomerTest'
                : 'Customer')
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
          'vat': _model.radioButtonValueControllerVat == null
              ? ''
              : _model.radioButtonValueControllerVat!.value,

          'ชื่อนามสกุล':
              '${_model.textControllerName.text} ${_model.textControllerSurname.text}',
          'ชื่อ': _model.textControllerName.text,
          'นามสกุล': _model.textControllerSurname.text,
          'วันเกิด': _model.textController2.text,
          'เดือนเกิด': _model.textController3.text,
          'ปีเกิด': _model.textController4.text,
          'เลขบัตรประชาชน': _model.textController5.text,

          'ใช้ที่อยู่ตามบัตร': checkIDforAddress,

          'บ้านเลขที่': homeAddress.text,
          'หมู่': mooAddress.text,
          'หมู่บ้าน': nameMooAddress.text,
          'ถนน': roadAddress.text,
          'จังหวัด': proviceAddress.text,
          'อำเภอ': districAddressController.text,
          'ตำบล': subDistricAddressController.text,
          'รหัสไปรษณีย์': codeAddress.text,

          'PhoneTypeCountry': number.dialCode == null
              ? ''
              : number.dialCode!.startsWith('+')
                  ? number.dialCode ?? ''
                  : '+${number.dialCode ?? ''}',
          'PhoneNumber': _model.textController6.text,
          'วันเริ่มจัดส่ง': _model.textController7.text,
          'เดือนเริ่มจัดส่ง': _model.textController8.text,
          'ปีเริ่มจัดส่ง': _model.textController9.text,
          'ชื่อร้านค้า': _model.textController10.text,
          'เป้าหมายยอดขาย': _model.textController11.text,
          'CategoryProductNow': productTypeFinal,
          'ระยะเวลาการดำเนินการ': _model.textController12.text,
          'ระยะเวลาการดำเนินการปี': _model.textController12.text,
          'ระยะเวลาการดำเนินการเดือน': _model.textController121.text,

          // 'วันสิ้นสุด': _model.textController12.text,
          // 'เดือนสิ้นสุด': _model.textController13.text,
          // 'ปีสิ้นสุด': _model.textController14.text,
          'CategoryProductOrder': dropDownValues2,
          'ListCustomerAddress': resultList,
          'ตารางราคา': _model.dropDownValue6 ?? '',
          // 'ที่อยู่จัดส่ง': _model.dropDownValue7,
          // 'ที่อยู่ออกบิล': _model.dropDownValue8,
          // 'ที่อยู่อื่น': _model.dropDownValue9,

          'ลิสต์จัดส่งและออกบิล': resultListSendAndBill,
          'ระยะเวลาชำระหนี้': _model.textController191.text,
          'วงเงินเครดิต': _model.textController19.text,
          'ส่วนลดบิล': _model.textController20.text,
          'ประเภทชำระ': _model.dropDownValue11 ?? '',
          'เงื่อนไขชำระ': _model.dropDownValue12 ?? '',
          'บัญชีธนาคารของบริษัท': _model.dropDownValue13 ?? '',
          'แผนก': _model.dropDownValue14 ?? '',
          'รหัสบัญชี': _model.dropDownValue15 ?? '',
          'รหัสพนักงานขาย': widget.entryMap!['value']['รหัสพนักงานขาย'],
          'ชื่อพนักงานขาย': widget.entryMap!['value']['ชื่อพนักงานขาย'],
          'รหัสกลุ่มลูกค้า': _model.dropDownValue18 ?? '',
          'รหัสกลุ่มลูกค้า2': _model.dropDownValue182 ?? '',
          'รหัสกลุ่มลูกค้า3': _model.dropDownValue183 ?? '',
          'รหัสกลุ่มลูกค้า4': _model.dropDownValue184 ?? '',
          'รหัสกลุ่มลูกค้า5': _model.dropDownValue185 ?? '',
          'รหัสบัญชี2': _model.dropDownValue19,
          'รูปร้านค้า': listUrl,
          // 'รูปเอกสาร': listUrl2,
          'รูปเอกสาร': listOfMaps,
          'ไฟล์เอกสาร': listFileOfMaps,
          'ลายเซ็น': widget.entryMap!['value']['ลายเซ็น'] != ''
              ? widget.entryMap!['value']['ลายเซ็น']
              : signatureUrl,
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

          // 'SectionID': widget.entryMap!['value']['สถานะ'] == false &&
          //         widget.entryMap!['value']['รอการอนุมัติ'] == false &&
          //         widget.entryMap!['value']['บันทึกพร้อมตรวจ'] == false
          //     ? '20231208151899'
          //     : widget.entryMap!['value']['SectionID'],

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
          // print(number.dialCode);
        });
      }
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

  void refreshAddressForDropdown(StateSetter setStateIN, index) {
    // listBillTaxIndex.clear();

    List<int> dropDownControllersBillIndex = [];

    List<int> dropDownControllersSendIndex = [];

    List<String> dropDownControllersBillTaxIndex = [];

    print(dropDownControllersBillTax.length);
    print(dropDownControllersBillTax);

    for (int i = 0; i < dropDownControllersBillTax.length; i++) {
      if (dropDownControllersBillTax[i].value == null) {
        dropDownControllersBillTax[i].value = '';
      }

      // print(dropDownControllersBillTax[i].value!);
      int index = addressAllForDropdownForCheckIndex
          .indexOf(dropDownControllersBillTax[i].value!.trimLeft().trimRight());
      if (index != -1) {
        print('Index found: $index');
        dropDownControllersBillTaxIndex.add(index.toString());
        // listBillTaxIndex.add(index.toString());
      } else {
        dropDownControllersBillTaxIndex.add('');
        // listBillTaxIndex.add('');

        print('Index not found');
      }
    }

    // for (int i = 0; i < dropDownControllersBill.length; i++) {
    //   int index = addressAllForDropdown
    //       .indexOf(dropDownControllersBill[i].value!.trimLeft().trimRight());
    //   if (index != -1) {
    //     dropDownControllersBillIndex.add(index);
    //   } else {
    //     print('Index not found');
    //   }
    // }

    // for (int i = 0; i < dropDownControllersSend.length; i++) {
    //   int index = addressAllForDropdown
    //       .indexOf(dropDownControllersSend[i].value!.trimLeft().trimRight());
    //   if (index != -1) {
    //     print('Index found: $index');
    //     dropDownControllersSendIndex.add(index);
    //   } else {
    //     print('Index not found');
    //   }
    // }

    return setStateIN(() {
      addressAllForDropdownForCheckIndex.clear();

      addressAllForDropdown.clear();
      //====================================================================
      List<Map<String, dynamic>> addressThai = [];

      for (int i = 0; i < resultList.length; i++) {
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
          'tambon_name': tambonName! == '' ? tambonName : 'ต.' + tambonName,
        });

        String texttt =
            '${resultList[i]['รหัสสาขา']} ${resultList[i]['ชื่อสาขา']} ${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${resultList[i]['Road']} ${resultList[i]['SubDistrict']} ${resultList[i]['District']} ${resultList[i]['Province']} ${resultList[i]['PostalCode']} ${resultList[i]['ผู้ติดต่อ']} ${resultList[i]['ตำแหน่ง']} ${resultList[i]['โทรศัพท์']}';

        String resultString =
            texttt.replaceFirst('${resultList[i]['ID']}', '').trim();

        // addressAllForDropdown.add(resultString);
        if (resultString == '' || resultString.isEmpty) {
          addressAllForDropdownForCheckIndex.add('ไม่มีตัวเลือก');
        } else {
          addressAllForDropdown.add(resultString);
          addressAllForDropdownForCheckIndex.add(resultString);
        }

        String texttt2 =
            '${resultList[i]['รหัสสาขา']} ${resultList[i]['ชื่อสาขา']} ${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${resultList[i]['Road']} ${resultList[i]['Province']} ${resultList[i]['District']} ${resultList[i]['SubDistrict']} ${resultList[i]['PostalCode']} ${resultList[i]['ผู้ติดต่อ']} ${resultList[i]['ตำแหน่ง']} ${resultList[i]['โทรศัพท์']}';
      }

      // for (int i = 0; i < dropDownControllersBillIndex.length; i++) {
      //   dropDownControllersBill[i].reset();
      //   dropDownControllersBill[i].value =
      //       addressAllForDropdown[dropDownControllersBillIndex[i]];
      // }

      // for (int i = 0; i < dropDownControllersSendIndex.length; i++) {
      //   dropDownControllersSend[i].reset();
      //   dropDownControllersSend[i].value =
      //       addressAllForDropdown[dropDownControllersSendIndex[i]];
      // }

      //=====================================================

      for (int i = 0; i < dropDownControllersBillTaxIndex.length; i++) {
        if (dropDownControllersBillTaxIndex[i] == '') {
          dropDownControllersBillTax[i].reset();
          dropDownControllersBillTax[i].value = '';
        } else {
          dropDownControllersBillTax[i].reset();
          dropDownControllersBillTax[i].value =
              addressAllForDropdownForCheckIndex[
                  int.parse(dropDownControllersBillTaxIndex[i])];
        }
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is Form Edit General User ');
    print('==============================');
    print(widget.entryMap!['value']['CustomerID']);
    userData = userController.userData;

    // print(checkStatusToButtonEdit);
    // print(checkStatusToEdit);
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
              SingleChildScrollView(
                // controller: _scrollController,
                child: Form(
                  key: _formKey,
                  child: SizedBox(
                    height: boolEditApprove
                        ? 1100
                        : widget.entryMap!['value']['สถานะ'] == false &&
                                widget.entryMap!['value']['บันทึกพร้อมตรวจ'] ==
                                    false &&
                                widget.entryMap!['value']['รอการอนุมัติ'] ==
                                    false &&
                                checkStatusToButtonEdit
                            ? 950
                            : (widget.entryMap!['value']['สถานะ'] == true &&
                                        widget.entryMap!['value']
                                                ['รอการอนุมัติ'] ==
                                            false &&
                                        widget.entryMap!['value']
                                                ['บันทึกพร้อมตรวจ'] ==
                                            false) ||
                                    (widget.entryMap!['value']['สถานะ'] ==
                                            false &&
                                        widget.entryMap!['value']
                                                ['รอการอนุมัติ'] ==
                                            true &&
                                        widget.entryMap!['value']
                                                ['บันทึกพร้อมตรวจ'] ==
                                            false)
                                ? 1100
                                : 1000,
                    child: SingleChildScrollView(
                      controller: _scrollController,
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

                            widget.entryMap!['value']['รอการอนุมัติ'] == false
                                ? SizedBox()
                                : StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('ApproveComment')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox();
                                      }
                                      if (snapshot.hasError) {
                                        return Text(
                                            'เกิดข้อผิดพลาด: ${snapshot.error}');
                                      }
                                      if (!snapshot.hasData) {
                                        return Text('ไม่พบข้อมูล');
                                      }
                                      if (snapshot.data!.docs.isEmpty) {
                                        print(snapshot.data);
                                      }
                                      print('ApproveComment');
                                      List<Map<String, dynamic>> dataList = [];

                                      for (int index = 0;
                                          index < snapshot.data!.docs.length;
                                          index++) {
                                        Map<String, dynamic> currentData =
                                            snapshot.data!.docs[index].data()
                                                as Map<String, dynamic>;
                                        dataList.add(currentData);
                                      }

                                      Map<String, dynamic>? foundMap;

                                      for (Map<String, dynamic> map
                                          in dataList) {
                                        if (map["CustomerID"] ==
                                            widget.entryMap!['value']
                                                ['CustomerID']) {
                                          foundMap = map;
                                          break;
                                        }
                                      }

                                      // ตรวจสอบว่าพบหรือไม่
                                      if (foundMap != null) {
                                        print(
                                            "พบ Map ที่มี CustomerID เท่ากับ ${widget.entryMap!['value']['CustomerID']}: $foundMap");
                                      } else {
                                        print(
                                            "ไม่พบ Map ที่มี CustomerID เท่ากับ ${widget.entryMap!['value']['CustomerID']}");
                                      }
                                      return Align(
                                        alignment:
                                            AlignmentDirectional(0.00, 0.00),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 20.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                foundMap == null
                                                    ? 'ยังไม่มีรายชื่อตรวจสอบ'
                                                    : foundMap['UserName'],
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
                                        ),
                                      );
                                    }),
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                            ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 5,
                            ),
                            // GestureDetector(
                            //   onLongPress: () {
                            //     Clipboard.setData(ClipboardData(
                            //         text: widget.entryMap.toString()));
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(
                            //         content: Text('Copied to clipboard'),
                            //       ),
                            //     );
                            //   },
                            //   child: Text(
                            //     widget.entryMap!.toString(),
                            //     style: TextStyle(fontSize: 18.0),
                            //   ),
                            // ),

                            //========================  Approve Comment =====================================
                            const SizedBox(
                              height: 5,
                            ),
                            approveComment(context),
                            //========================  ocr =====================================
                            widget.type == 'Company'
                                ? const SizedBox(
                                    height: 5,
                                  )
                                : IgnorePointer(
                                    ignoring: !checkStatusToEdit,
                                    child: ocrEdit(context)),

                            //============================================================
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: Colors.black.withOpacity(0.5))),
                              ),
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                              alignment: Alignment.centerRight,
                              child: Text(
                                'ส่วนที่ 1.ข้อมูลลูกค้า',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ),
                            widget.type == 'Company'
                                ? SizedBox(
                                    height: 10,
                                  )
                                : SizedBox(
                                    height: 5,
                                  ),
                            //============================================================
                            //======================= checkbox คำนำหน้า ======================================
                            widget.type == 'Company'
                                ? const SizedBox()
                                : IgnorePointer(
                                    ignoring: !checkStatusToEdit,
                                    child: typeNameEdit(context)),
                            //=========================== ชื่อ นามสกุล /ชื่อบริษัn==================================

                            widget.type == 'Company'
                                ? IgnorePointer(
                                    ignoring: !checkStatusToEdit,
                                    child: nameCompany(context))
                                : Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: IgnorePointer(
                                            ignoring: !checkStatusToEdit,
                                            child: namePersanal(context)),
                                      ),
                                      Expanded(
                                        child: IgnorePointer(
                                            ignoring: !checkStatusToEdit,
                                            child: surnamePersanal(context)),
                                      ),
                                    ],
                                  ),

                            //======================= checkbox vat ======================================
                            widget.type == 'Company'
                                ? IgnorePointer(
                                    ignoring: !checkStatusToEdit,
                                    child: vatCompanyEdit(context))
                                : SizedBox(),

                            //======================= วันเดือนปีเกิด/วันเดือนปีที่จัดจัดตั้ง ======================================
                            widget.type == 'Company'
                                ? IgnorePointer(
                                    ignoring: !checkStatusToEdit,
                                    child: birthdayCompanyEdit())
                                : IgnorePointer(
                                    ignoring: !checkStatusToEdit,
                                    child: birthdayCustomerEdit()),

                            //======================= เลขประจำตัวผู้เสียภาษี ======================================
                            widget.type == 'Company'
                                ? IgnorePointer(
                                    ignoring: !checkStatusToEdit,
                                    child: idCompanyEdit(context))
                                : const SizedBox(),
                            //======================= ทุนจดทะเบียน / เลขที่บัตรประชาชน   ======================================
                            widget.type == 'Company'
                                ? IgnorePointer(
                                    ignoring: !checkStatusToEdit,
                                    child: companyFundEdit(context))
                                : IgnorePointer(
                                    ignoring: !checkStatusToEdit,
                                    child: idCustomerEdit()),
                            SizedBox(
                              height: 5,
                            ),
                            IgnorePointer(
                              ignoring: !checkStatusToEdit,
                              child: houseNumberFirst(context),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            IgnorePointer(
                              ignoring: !checkStatusToEdit,
                              child: mooFirst(context),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            IgnorePointer(
                              ignoring: !checkStatusToEdit,
                              child: nameMooFirst(context),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            IgnorePointer(
                              ignoring: !checkStatusToEdit,
                              child: roadFirst(context),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),

                            IgnorePointer(
                              ignoring: !checkStatusToEdit,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: dropdownProvince(
                                  list: provinces,
                                  child: 'amphure',
                                ),
                              ),
                            ),
                            // SizedBox(height: 10.0),
                            IgnorePointer(
                              ignoring: !checkStatusToEdit,
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                                child: dropdownAmphor(
                                  list: amphuresListFirst,
                                  child: 'tambon',
                                ),
                              ),
                            ),
                            // SizedBox(height: 10.0),
                            IgnorePointer(
                              ignoring: !checkStatusToEdit,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: dropdownTambon(
                                  list: tambonsListFirst,
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // proviceFirst(context),
                            // SizedBox(
                            //   height: 10,
                            // ),

                            // districFirst(context),
                            // SizedBox(
                            //   height: 10,
                            // ),

                            // subDistricFirst(context),
                            // SizedBox(
                            //   height: 10,
                            // ),

                            IgnorePointer(
                              ignoring: !checkStatusToEdit,
                              child: codeFirst(context),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            //===================== เบอร์โทรศัพท์ ========================================
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: phoneEdit(context)),
                            //===================== วัน / เดือน / ปี ที่เริ่มจัดส่ง  ========================================
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: dateToSendEdit()),
                            //=========================== ชื่อร้าน/แผงในตลาด ==================================
                            IgnorePointer(
                              ignoring: !checkStatusToEdit,
                              child: shopNameEdit(context),
                            ), //=============================================================

                            //============================= dropdown ประเภทสินค้าที่ขายในปัจจุบัน ================================
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: groupProductEdit()),

                            //======================== ระยะเวลาการดำเนินการ=====================================
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: dateToWorkEdit(context)),

                            //======================== dropdown กลุ่มสินค้าท่สั่งซืื้อ =====================================
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: groupProdutcoBuyEdit()),
                            //=============================================================================
                            widget.type == 'Company'
                                ? SizedBox(
                                    height: 10,
                                  )
                                : SizedBox(
                                    height: 5,
                                  ),

                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: Colors.black.withOpacity(0.5))),
                              ),
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                              alignment: Alignment.centerRight,
                              child: Text(
                                'ส่วนที่ 2.ที่อยู่ในการจัดส่งและออกในใบกำกับภาษี',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ),
                            widget.type == 'Company'
                                ? SizedBox(
                                    height: 10,
                                  )
                                : SizedBox(
                                    height: 5,
                                  ),

                            //=========================== หัวข้อ ที่อยู่ในการจัดส่ง ==================================
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 0.0, 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'ที่อยู่ในการจัดส่ง (ระบุได้มากกว่า 1 สถานที่) โดยเลือก จังหวัด ,อำเภอ , ตำบล , รหัสไปรษณีย์',
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                ],
                              ),
                            ),

                            IgnorePointer(
                              ignoring: !checkStatusToEdit,
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: checkIDforAddress,
                                    onChanged: (value) {
                                      setState(() {
                                        checkIDforAddress = !checkIDforAddress;
                                        if (checkIDforAddress) {
                                          houseNumber.text = homeAddress.text;
                                          moo.text = mooAddress.text;
                                          nameMoo.text = nameMooAddress.text;
                                          raod.text = roadAddress.text;
                                          province.text = proviceAddress.text;
                                          district.text =
                                              districAddressController.text;
                                          subDistrict.text =
                                              subDistricAddressController.text;
                                          postalCodeController![0].text =
                                              codeAddress.text;

                                          // print(homeAddress.text);
                                          // print(homeAddress.text);
                                          // print(homeAddress.text);
                                          // print(homeAddress.text);
                                          // print(homeAddress.text);

                                          resultList[0]['HouseNumber'] =
                                              homeAddress.text;
                                          resultList[0]['Moo'] =
                                              mooAddress.text;
                                          resultList[0]['VillageName'] =
                                              nameMooAddress.text;
                                          resultList[0]['Road'] =
                                              roadAddress.text;
                                          resultList[0]['Province'] =
                                              proviceAddress.text
                                                  .split(' - ')[0];
                                          resultList[0]['District'] =
                                              districAddressController.text
                                                  .split(' - ')[0];
                                          resultList[0]['SubDistrict'] =
                                              subDistricAddressController.text
                                                  .split(' - ')[0];
                                          resultList[0]['PostalCode'] =
                                              codeAddress.text;
                                        }
                                      });
                                    },
                                  ),
                                  Text(
                                    'เลือกที่อยู่ตามบัตรประชาชน',
                                    style:
                                        FlutterFlowTheme.of(context).labelLarge,
                                  ),
                                ],
                              ),
                            ),

                            //=========================== ลิสต์ที่อยู่ในการจัดส่ง ==================================
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: addressShopEdit()),

                            //==================== ตารางราคา API =========================================
                            // Padding(
                            //   padding: EdgeInsetsDirectional.fromSTEB(
                            //       8.0, 5.0, 0.0, 0.0),
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.max,
                            //     children: [
                            //       Text(
                            //         ' ตารางราคา (MFOOD API) (เพื่อใช้ผูกกับที่อยู่ในการจัดส่ง)',
                            //         style:
                            //             FlutterFlowTheme.of(context).bodySmall,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // IgnorePointer(
                            //     ignoring: !checkStatusToEdit,
                            //     child: priceTableApiEdit()),
                            //========================== หัวข้อ แผนที่ ===================================
                            // Padding(
                            //   padding: EdgeInsetsDirectional.fromSTEB(
                            //       8.0, 5.0, 0.0, 5.0),
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.max,
                            //     children: [
                            //       Text(
                            //         'พิกัด GPS (Google Map Pin location)',
                            //         style:
                            //             FlutterFlowTheme.of(context).bodyMedium,
                            //       ),
                            //       Padding(
                            //         padding: EdgeInsetsDirectional.fromSTEB(
                            //             5.0, 0.0, 0.0, 0.0),
                            //         child: Icon(
                            //           FFIcons.kstoreMarker,
                            //           color: FlutterFlowTheme.of(context)
                            //               .secondaryText,
                            //           size: 24.0,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            // //======================= แผนที่ ======================================
                            // IgnorePointer(
                            //     ignoring: !checkStatusToEdit,
                            //     child: mapEdit(context)),
                            // //========================= หัวข้อ รูปภาพร้านค้า ====================================
                            // Padding(
                            //   padding: EdgeInsetsDirectional.fromSTEB(
                            //       0.0, 5.0, 0.0, 5.0),
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.max,
                            //     children: [
                            //       Padding(
                            //         padding: EdgeInsetsDirectional.fromSTEB(
                            //             8.0, 5.0, 0.0, 5.0),
                            //         child: Text(
                            //           'รูปภาพร้านค้า อัพโหลดได้หลายภาพ (ต้องมีอย่างน้อย 1 รูป)',
                            //           style: FlutterFlowTheme.of(context)
                            //               .bodyMedium,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // //==========================  รูปถ่ายร้านค้า  ===================================
                            // imageFile.length > 3
                            //     ? IgnorePointer(
                            //         ignoring: !checkStatusToEdit,
                            //         child: imageMoreThreeEdit(context))
                            //     : IgnorePointer(
                            //         ignoring: !checkStatusToEdit,
                            //         child: imageLessThreeEdit(context)),
                            //================== หัวข้อ กำหนดที่อยูในการจัดส่ง ===========================================
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            // IgnorePointer(
                            //     ignoring: !checkStatusToEdit,
                            //     child: addressToBillAndSendChooseEdit()),
                            //=============================================================================
                            widget.type == 'Company'
                                ? SizedBox(
                                    height: 10,
                                  )
                                : SizedBox(
                                    height: 5,
                                  ),

                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: Colors.black.withOpacity(0.5))),
                              ),
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                              alignment: Alignment.centerRight,
                              child: Text(
                                'ส่วนที่ 3.ข้อมูลการวางบิล/ข้อมูลอื่นๆ',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ),
                            widget.type == 'Company'
                                ? SizedBox(
                                    height: 10,
                                  )
                                : SizedBox(
                                    height: 5,
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
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: payChooseEdit(dataPay)),
                            //======================== ระยะเวลาชำระหนี้ =====================================
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    ' ระยะเวลาชำระหนี้ (Credit terms)',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: payOptionEdit()),
                            //=========================== วงเงินเครดิต ==================================
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: creditPayEdit(context)),

                            //=========================== เป้าการขาย ==================================
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: goalToSellEdit(context)),
                            //=========================  สวนลดท้ายบิล ====================================
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: billDiscountEdit(context)),
                            //=========================  ประเภทการจ่ายเงิน ====================================
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    ' ประเภทการจ่ายเงิน (Dropdown จาก API)',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: payOptionEditDropdown()),

                            //====================== เลือกบัญชีธนาคารของบริษัท =======================================
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    ' เลือกบัญชีธนาคารของบริษัท (MFOOD API)',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: bookBankEdit()),
                            //========================= แผนก ====================================
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    ' แผนก (MFOOD API)',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: departmentEdit()),
                            //======================== รหัสบัญชี =====================================
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    ' รหัสบัญชี (MFOOD API)',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: idAccoutingEdit()),
                            //========================  รหัสพนักงาน =====================================
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    ' รหัสพนักงานขาย (อ้างอิงจากรหัสพนักงานจากบัญชีผู้ใช้งานที่ Login เข้าระบบ)',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: idCustmerEdit(context)),
                            //========================  ชื่อ-สกุล พนักงาน  =====================================
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    ' ชื่อ-สกุล พนักงานขาย (อ้างอิงจากชื่อผู้ใช้จากบัญชีผู้ใช้งานที่ Login เข้าระบบ)',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),

                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: nameEmployeeEdit(context)),
                            //======================== รหัสกลุ่มลูกค้า =====================================
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    ' รหัสกลุ่มลูกค้า กลุ่ม 1 / MFOOD API\' (Require กลุ่มลูกค้า 1 ต้องเลือกข้อมูล)',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: idCustmerGroupOneEdit()),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    ' รหัสกลุ่มลูกค้า กลุ่ม 2 / MFOOD API\' (Require กลุ่มลูกค้า 1 ต้องเลือกข้อมูล)',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: idCustomerGroupTwoEdit()),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    ' รหัสกลุ่มลูกค้า กลุ่ม 3 / MFOOD API\' (Require กลุ่มลูกค้า 1 ต้องเลือกข้อมูล)',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: idCustomerGroupThreeEdit()),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    ' รหัสกลุ่มลูกค้า กลุ่ม 4 / MFOOD API\' (Require กลุ่มลูกค้า 1 ต้องเลือกข้อมูล)',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: idCustomerGroupFourEdit()),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 5.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    ' รหัสกลุ่มลูกค้า กลุ่ม 5 / MFOOD API\' (Require กลุ่มลูกค้า 1 ต้องเลือกข้อมูล)',
                                    style:
                                        FlutterFlowTheme.of(context).bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: idCustomerGroupFiveEdit()),

                            //=============================================================================
                            widget.type == 'Company'
                                ? SizedBox(
                                    height: 10,
                                  )
                                : SizedBox(
                                    height: 5,
                                  ),

                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: Colors.black.withOpacity(0.5))),
                              ),
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                              alignment: Alignment.centerRight,
                              child: Text(
                                'ส่วนที่ 4.เอกสารอ้างอิง/รูปภาพอ้างอิง',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                            ),
                            widget.type == 'Company'
                                ? SizedBox(
                                    height: 10,
                                  )
                                : SizedBox(
                                    height: 5,
                                  ),

                            //======================  รูปสำหรับเอกสาร =======================================
                            IgnorePointer(
                                ignoring: !checkStatusToEdit,
                                child: paperAddEdit(context)),

                            //========================== ลายเซ็น  ===================================
                            // imageSignFirestore.isEmpty
                            //     ? signButton()
                            //     :
                            // signNetwork(context),
                            //=============================================================
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //========================== เซฟไว้ทำทีหลัง  ===================================
              boolEditApprove
                  ? SizedBox()
                  : (widget.entryMap!['value']['สถานะ'] == true &&
                              widget.entryMap!['value']['รอการอนุมัติ'] ==
                                  false &&
                              widget.entryMap!['value']['บันทึกพร้อมตรวจ'] ==
                                  false) ||
                          (widget.entryMap!['value']['สถานะ'] == false &&
                              widget.entryMap!['value']['รอการอนุมัติ'] ==
                                  true &&
                              widget.entryMap!['value']['บันทึกพร้อมตรวจ'] ==
                                  false)
                      ? SizedBox()
                      : checkStatusToButtonEdit
                          ? toEditButton(context)
                          : saveButton(context),

              //========================== เฉพาะหน้า ไม่ผ่านการอนุมัติ  ===================================
              boolEditApprove
                  ? SizedBox()
                  : widget.entryMap!['value']['สถานะ'] == false &&
                          widget.entryMap!['value']['บันทึกพร้อมตรวจ'] ==
                              false &&
                          widget.entryMap!['value']['รอการอนุมัติ'] == false &&
                          checkStatusToButtonEdit
                      ? saveButtonReject(context, checkStatusToEdit)
                      : SizedBox(),
              //========================== เซฟแล้วดำเนินการต่อไป  ===================================
              boolEditApprove
                  ? SizedBox()
                  : (widget.entryMap!['value']['สถานะ'] == true &&
                              widget.entryMap!['value']['รอการอนุมัติ'] ==
                                  false &&
                              widget.entryMap!['value']['บันทึกพร้อมตรวจ'] ==
                                  false) ||
                          (widget.entryMap!['value']['สถานะ'] == false &&
                              widget.entryMap!['value']['รอการอนุมัติ'] ==
                                  true &&
                              widget.entryMap!['value']['บันทึกพร้อมตรวจ'] ==
                                  false)
                      ? SizedBox()
                      : approveButton(context, checkStatusToEdit),
            ],
          );
  }

  Padding namePersanal(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        onChanged: (value) {
          _model.textControllerName = TextEditingController(text: value);
        },
        controller: _model.textControllerName,
        focusNode: _model.textFieldFocusNodeName,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'ชื่อ',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'ชื่อ',
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
        // validator: _model.textController1Validator.asValidator(context),
      ),
    );
  }

  Padding surnamePersanal(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        onChanged: (value) {
          _model.textControllerSurname = TextEditingController(text: value);
        },
        controller: _model.textControllerSurname,
        focusNode: _model.textFieldFocusNodeSurname,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'นามสกุล',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'นามสกุล',
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
        // validator: _model.textController1Validator.asValidator(context),
      ),
    );
  }

  Padding approveButton(BuildContext context, bool checkStatusToEdit) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 0.0),
      child: FFButtonWidget(
        onPressed: () {
          if (checkStatusToEdit) {
            if (checkTimeToSend) {
              Fluttertoast.showToast(
                msg: "วันที่จัดส่ง ต้องไม่น้อยกว่าปัจจุบันค่ะ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 4,
                backgroundColor: Colors.red.shade900,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              scrollUp();
              return;
            }

            if (_model.dropDownValue18 == null) {
              Fluttertoast.showToast(
                msg: "กรุณาเลือกรหัสกลุ่มลูกค้า ที่ 1 ด้วยค่ะ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 4,
                backgroundColor: Colors.red.shade900,
                textColor: Colors.white,
                fontSize: 16.0,
              );

              return;
            }
            if (_model.dropDownValue18!.isEmpty ||
                _model.dropDownValue18 == '') {
              Fluttertoast.showToast(
                msg: "กรุณาเลือกกลุ่มลูกค้า ที่ 1 ด้วยค่ะ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 4,
                backgroundColor: Colors.red.shade900,
                textColor: Colors.white,
                fontSize: 16.0,
              );

              return;
            }
            print('Button pressed ... Confirm');
            // Set<String> uniqueImages = Set<String>();
            // for (int i = 0; i < resultList.length; i++) {
            //   if (resultList[i]['Image'].isEmpty ||
            //       resultList[i]['Image'] == '') {
            //     Fluttertoast.showToast(
            //       msg:
            //           "คุณมีร้านค้า ${resultList.length} สถานที่ กรุณาอ้างอิงรูปภาพในทุกๆ สถานที่\nอย่างน้อย 1 รูปภาพค่ะ",
            //       toastLength: Toast.LENGTH_SHORT,
            //       gravity: ToastGravity.TOP,
            //       timeInSecForIosWeb: 4,
            //       backgroundColor: Colors.red.shade900,
            //       textColor: Colors.white,
            //       fontSize: 16.0,
            //     );
            //     setState(
            //       () => checkSummit = true,
            //     );
            //     return;
            //   }
            //   if (!uniqueImages.add(resultList[i]['Image'])) {
            //     // ถ้าเจอว่าซ้ำ
            //     Fluttertoast.showToast(
            //       msg: "รูปภาพอ้างอิงร้านค้า ต้องไม่ซ้ำกันค่ะ",
            //       toastLength: Toast.LENGTH_SHORT,
            //       gravity: ToastGravity.TOP,
            //       timeInSecForIosWeb: 4,
            //       backgroundColor: Colors.red.shade900,
            //       textColor: Colors.white,
            //       fontSize: 16.0,
            //     );
            //     setState(() => checkSummit = true);
            //     return;
            //   }
            // }

            if (widget.type == 'Company') {
              if (_model.radioButtonValueControllerVat!.value == null ||
                  _model.radioButtonValueControllerVat!.value == '') {
                Fluttertoast.showToast(
                  msg: "กรุณาเลือกว่า บริษัทของคุณ มี vat หรือไม่ค่ะ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 4,
                  backgroundColor: Colors.red.shade900,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                // setState(
                //   () => checkSummit = true,
                // );
                return;
              }
            }

            if (widget.type == 'Company') {
              if (_model.radioButtonValueControllerVat!.value == 'มี') {
                // ถ้าเอกสารนิติบุคคลมีvat [true,true,true,true,false]
                for (int i = 0; i < 4; i++) {
                  if (i == 0) {
                    if (imageUint8ListList2![0]!.isEmpty &&
                        finalFileResultString![0]!.isEmpty &&
                        fileUrlFromFirestoreList![0]!.isEmpty &&
                        imageUrlFromFirestoreList2![0]!.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "คุณยังไม่แนบไฟล์สำเนาบัตรประชาชนของกรรมการค่ะ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red.shade900,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      // setState(
                      //   () => checkSummit = true,
                      // );
                      return;
                    }
                  } else if (i == 1) {
                    if (imageUint8ListList2![1]!.isEmpty &&
                        finalFileResultString![1]!.isEmpty &&
                        fileUrlFromFirestoreList![1]!.isEmpty &&
                        imageUrlFromFirestoreList2![1]!.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "คุณยังไม่แนบไฟล์หนังสือรับรองบริษัทค่ะ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red.shade900,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      // setState(
                      //   () => checkSummit = true,
                      // );
                      return;
                    }
                  } else if (i == 2) {
                    if (imageUint8ListList2![2]!.isEmpty &&
                        finalFileResultString![2]!.isEmpty &&
                        fileUrlFromFirestoreList![2]!.isEmpty &&
                        imageUrlFromFirestoreList2![2]!.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "คุณยังไม่แนบไฟล์ ภพ.20 ค่ะ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red.shade900,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      // setState(
                      //   () => checkSummit = true,
                      // );
                      return;
                    }
                  }
                  //  else if (i == 3) {
                  //   if (imageUint8ListList2![3]!.isEmpty &&
                  //       finalFileResultString![3]!.isEmpty &&
                  //       fileUrlFromFirestoreList![3]!.isEmpty &&
                  //       imageUrlFromFirestoreList2![3]!.isEmpty) {
                  //     Fluttertoast.showToast(
                  //       msg: "คุณยังไม่แนบไฟล์แผนที่ในการจัดส่งสินค้าค่ะ",
                  //       toastLength: Toast.LENGTH_SHORT,
                  //       gravity: ToastGravity.TOP,
                  //       timeInSecForIosWeb: 4,
                  //       backgroundColor: Colors.red.shade900,
                  //       textColor: Colors.white,
                  //       fontSize: 16.0,
                  //     );
                  //     // setState(
                  //     //   () => checkSummit = true,
                  //     // );
                  //     return;
                  //   }
                  // }
                  else {}
                }
              } else {
                // ถ้าเอกสารนิติบุคคลไม่มีvat [true,true,false,true,false]
                for (int i = 0; i < 4; i++) {
                  if (i == 0) {
                    if (imageUint8ListList2![0]!.isEmpty &&
                        finalFileResultString![0]!.isEmpty &&
                        fileUrlFromFirestoreList![0]!.isEmpty &&
                        imageUrlFromFirestoreList2![0]!.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "คุณยังไม่แนบไฟล์สำเนาบัตรประชาชนของกรรมการค่ะ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red.shade900,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      // setState(
                      //   () => checkSummit = true,
                      // );
                      return;
                    }
                  } else if (i == 1) {
                    if (imageUint8ListList2![1]!.isEmpty &&
                        finalFileResultString![1]!.isEmpty &&
                        fileUrlFromFirestoreList![1]!.isEmpty &&
                        imageUrlFromFirestoreList2![1]!.isEmpty) {
                      Fluttertoast.showToast(
                        msg: "คุณยังไม่แนบไฟล์หนังสือรับรองบริษัทค่ะ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red.shade900,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      // setState(
                      //   () => checkSummit = true,
                      // );
                      return;
                    }
                  }
                  // else if (i == 3) {
                  //   if (imageUint8ListList2![3]!.isEmpty &&
                  //       finalFileResultString![3]!.isEmpty &&
                  //       fileUrlFromFirestoreList![3]!.isEmpty &&
                  //       imageUrlFromFirestoreList2![3]!.isEmpty) {
                  //     Fluttertoast.showToast(
                  //       msg: "คุณยังไม่แนบไฟล์แผนที่ในการจัดส่งสินค้าค่ะ",
                  //       toastLength: Toast.LENGTH_SHORT,
                  //       gravity: ToastGravity.TOP,
                  //       timeInSecForIosWeb: 4,
                  //       backgroundColor: Colors.red.shade900,
                  //       textColor: Colors.white,
                  //       fontSize: 16.0,
                  //     );
                  //     // setState(
                  //     //   () => checkSummit = true,
                  //     // );
                  //     return;
                  //   }
                  // }
                  else {}
                }
              }
            } else {
              // ถ้าเอกสารบุคคลธรรมดา [true,false,true,false,false]
              for (int i = 0; i < 3; i++) {
                if (i == 0) {
                  if (imageUint8ListList2![0]!.isEmpty &&
                      finalFileResultString![0]!.isEmpty &&
                      fileUrlFromFirestoreList![0]!.isEmpty &&
                      imageUrlFromFirestoreList2![0]!.isEmpty) {
                    Fluttertoast.showToast(
                      msg: "คุณยังไม่แนบไฟล์สำเนาบัตรประชาชนค่ะ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red.shade900,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    // setState(
                    //   () => checkSummit = true,
                    // );
                    return;
                  }
                }
                //  else if (i == 2) {
                //   if (imageUint8ListList2![2]!.isEmpty &&
                //       finalFileResultString![2]!.isEmpty &&
                //       fileUrlFromFirestoreList![2]!.isEmpty &&
                //       imageUrlFromFirestoreList2![2]!.isEmpty) {
                //     Fluttertoast.showToast(
                //       msg: "คุณยังไม่แนบไฟล์แผนที่ในการจัดส่งสินค้าค่ะ",
                //       toastLength: Toast.LENGTH_SHORT,
                //       gravity: ToastGravity.TOP,
                //       timeInSecForIosWeb: 4,
                //       backgroundColor: Colors.red.shade900,
                //       textColor: Colors.white,
                //       fontSize: 16.0,
                //     );
                //     // setState(
                //     //   () => checkSummit = true,
                //     // );
                //     return;
                //   }
                // }
                else {}
              }
            }
            trySummit(false, 'check');
          } else {
            print('No Edit');
          }
        },
        text: 'เซฟแล้วดำเนินการต่อไป',
        options: FFButtonOptions(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: 40.0,
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
    );
  }

  StreamBuilder approveComment(BuildContext context) {
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

    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('ApproveComment').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox();
          }
          if (snapshot.hasError) {
            return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Text('ไม่พบข้อมูล');
          }
          if (snapshot.data!.docs.isEmpty) {
            print(snapshot.data);
          }

          Map<String, dynamic> data = {};

          for (int index = 0; index < snapshot.data!.docs.length; index++) {
            final Map<String, dynamic> docData =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;

            if (docData['CustomerID'] ==
                widget.entryMap!['value']['CustomerID']) {
              data['key${index}'] = docData;
            }
          }
          print('Approve Comment');
          print(data);
          List<MapEntry<String, dynamic>> entriesList = data.entries.toList();

          return entriesList.length == 0
              ? SizedBox()
              : StatefulBuilder(builder: (context, setState) {
                  for (var entry in entriesList) {
                    if (entry.value['PositionName'] == 'ผู้อนุมัติคนที่ 5' &&
                        entry.value['ยื่นเอกสารใหม่'] == false) {
                      setState(() {
                        boolEditApprove = true;
                      });
                    }
                  }
                  print('===============================');
                  print('===============================');
                  print('===============================');
                  print('===============================');
                  print('===============================');
                  print('===============================');
                  print('===============================');
                  print('===============================');
                  print('===============================');
                  print('===============================');
                  print('===============================');
                  print('===============================');
                  print(boolEditApprove);

                  print('===============================');
                  print('===============================');
                  print('===============================');
                  print('===============================');

                  return Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        8.0, 0.0, 8.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'คอมเมนท์ผู้อนุมัติ',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                        Container(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              8.0, 8.0, 8.0, 0.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              for (var entry in entriesList)
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 8.0, 8.0),
                                  child: Row(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            child:
                                                Icon(Icons.person_pin_outlined),
                                            backgroundColor:
                                                Colors.blue.shade900,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Container(
                                          // color: Colors.red,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${entry.value['PositionName']} วันที่ ${formatThaiDate(entry.value['DateCreate'])}',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium,
                                              ),
                                              Text(
                                                entry.value['Detail'],
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium,
                                              ),
                                              // TextFormField(
                                              //   readOnly: true,
                                              //   initialValue: entry.value['Detail'],
                                              //   // controller: _model.textController1Company,
                                              //   // focusNode: _model.textFieldFocusNode1Company,
                                              //   autofocus: false,
                                              //   obscureText: false,
                                              //   decoration: InputDecoration(
                                              //     labelText: entry.value['PositionName'],
                                              //     isDense: true,
                                              //     labelStyle:
                                              //         FlutterFlowTheme.of(context).labelMedium,
                                              //     hintText: entry.value['PositionName'],
                                              //     hintStyle:
                                              //         FlutterFlowTheme.of(context).labelMedium,
                                              //     enabledBorder: OutlineInputBorder(
                                              //       borderSide: BorderSide(
                                              //         color: FlutterFlowTheme.of(context)
                                              //             .alternate,
                                              //         width: 2.0,
                                              //       ),
                                              //       borderRadius: BorderRadius.circular(8.0),
                                              //     ),
                                              //     focusedBorder: OutlineInputBorder(
                                              //       borderSide: BorderSide(
                                              //         color:
                                              //             FlutterFlowTheme.of(context).primary,
                                              //         width: 2.0,
                                              //       ),
                                              //       borderRadius: BorderRadius.circular(8.0),
                                              //     ),
                                              //     errorBorder: OutlineInputBorder(
                                              //       borderSide: BorderSide(
                                              //         color: FlutterFlowTheme.of(context).error,
                                              //         width: 2.0,
                                              //       ),
                                              //       borderRadius: BorderRadius.circular(8.0),
                                              //     ),
                                              //     focusedErrorBorder: OutlineInputBorder(
                                              //       borderSide: BorderSide(
                                              //         color: FlutterFlowTheme.of(context).error,
                                              //         width: 2.0,
                                              //       ),
                                              //       borderRadius: BorderRadius.circular(8.0),
                                              //     ),
                                              //   ),
                                              //   style: FlutterFlowTheme.of(context).bodyMedium,
                                              //   textAlign: TextAlign.start,
                                              //   // validator: _model.textController1Validator.asValidator(context),
                                              // ),
                                            ],
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
                  );
                });
        });
  }

  Padding saveButtonReject(BuildContext context, bool checkStatusToEdit) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: FFButtonWidget(
        onPressed: () {
          if (checkStatusToEdit) {
            print('Button pressed ...');
            if (checkTimeToSend) {
              Fluttertoast.showToast(
                msg: "วันที่จัดส่ง ต้องไม่น้อยกว่าปัจจุบันค่ะ",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 4,
                backgroundColor: Colors.red.shade900,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              scrollUp();
              return;
            }
            trySummit(true, '');
          } else {
            print('No Edit');
          }
        },
        text: 'เซฟไว้ทำทีหลัง',
        options: FFButtonOptions(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: 40.0,
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: FlutterFlowTheme.of(context).accent3,
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
    );
  }

  Padding saveButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: FFButtonWidget(
        onPressed: () {
          print('Button pressed ...');
          if (checkTimeToSend) {
            Fluttertoast.showToast(
              msg: "วันที่จัดส่ง ต้องไม่น้อยกว่าปัจจุบันค่ะ",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 4,
              backgroundColor: Colors.red.shade900,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            scrollUp();
            return;
          }

          trySummit(true, '');
        },
        text: 'เซฟไว้ทำทีหลัง',
        options: FFButtonOptions(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: 40.0,
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
    );
  }

  Padding toEditButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: FFButtonWidget(
        onPressed: () {
          print('Button pressed ...');
          _scrollController.dispose();
          setState(() {
            _scrollController = ScrollController();
            checkStatusToEdit = true;
          });
          // trySummit(true);
        },
        text: 'แก้ไขข้อมูล',
        options: FFButtonOptions(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: 40.0,
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
    );
  }

  Align signNetwork(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.00, 0.00),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 15.0, 8.0, 5.0),
        child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.63,
              height: 200.0,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: imageSignFirestore == '' || imageSignFirestore.isEmpty
                    ? SizedBox()
                    : Image.network(
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
            )),
      ),
    );
  }

  Align signButton() {
    return Align(
      alignment: Alignment.center,
      child: StatefulBuilder(builder: (context, setState) {
        print(signConfirm);
        return Column(
          children: [
            signConfirm
                ? SizedBox()
                : Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        print('sign pressed ...');
                        // trySummit(true);
                        await signBottomSheet();
                        print('finish sign');
                        print(signConfirm);
                        if (mounted) {
                          setState(
                            () {},
                          );
                        }
                      },
                      text: 'ลายเซ็น',
                      options: FFButtonOptions(
                        width: MediaQuery.sizeOf(context).width * 0.25,
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).secondary,
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
            //========================== ลายเซ็น  ===================================
            signConfirm ? signShowEdit(context) : SizedBox()
          ],
        );
      }),
    );
  }

  Align signShowEdit(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.00, 0.00),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 15.0, 8.0, 5.0),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
          child: Container(
              width: MediaQuery.of(context).size.width * 0.63,
              height: 200.0,
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
              child: imageSignToShow

              //  Signature(
              //   color: Colors.blue.shade800,
              //   // color: FlutterFlowTheme.of(context)
              //   //     .secondaryText,
              //   key: _sign,
              //   onSign: () {
              //     final sign =
              //         _sign.currentState;
              //     debugPrint(
              //         '${sign!.points.length} points in the signature');
              //   },
              //   backgroundPainter:
              //       WatermarkPaint(
              //           "2.0", "2.0"),
              //   strokeWidth: strokeWidth,
              // ),
              ),
        ),
      ),
    );
  }

  Padding paperAddEdit(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'กรุณาแนบเอกสารดั่งต่อไปนี้',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: imageUint8ListList2![0]!.isEmpty &&
                            finalFileResultString![0]!.isEmpty &&
                            fileUrlFromFirestoreList![0]!.isEmpty &&
                            imageUrlFromFirestoreList2![0]!.isEmpty
                        ? Colors.grey.shade500
                        : Colors.green.shade900,
                    size: 15.0,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.type == 'Company'
                        ? '1) สําเนาบัตรประชาชนของกรรมการ (บังคับ)'
                        : '1) สําเนาบัตรประชาชน (บังคับ)',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      imageDialog2(
                        widget.type == 'Company'
                            ? '(สําเนาบัตรประชาชนของกรรมการ)'
                            : '(สําเนาบัตรประชาชน)',
                        0,
                      );
                    },
                    child: Icon(
                      FFIcons.kpaperclipPlus,
                      color: Colors.black,
                      size: 15.0,
                    ),
                  ),
                ],
              ),
              for (int index = 0;
                  index < finalFileResultString![0]!.length;
                  index++)
                finalFileResultString![0]![index].isNotEmpty
                    ? Container(
                        color: null,
                        width: 600,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                // if (!await launchURL(
                                //     finalFileResultString![
                                //         0]![index])) {
                                //   throw Exception(
                                //       'Could not launch ${finalFileResultString![0]![index]}');
                                // }

                                OpenFile.open(
                                    finalFileResultString![0]![index]);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '- ไฟล์ที่ ${index + 1}',
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.search,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    finalFileResultString![0]!.removeAt(index);
                                    fileUrlFromFirestoreList![0]!
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
                      )
                    : Container(
                        color: null,
                        width: 600,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (!await launchURL(
                                    fileUrlFromFirestoreList![0]![index])) {
                                  throw Exception(
                                      'Could not launch ${fileUrlFromFirestoreList![0]![index]}');
                                }

                                // OpenFile.open(
                                //     finalFileResultString![
                                //         4]![index]);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '- ไฟล์ที่ ${index + 1}',
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.search,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    finalFileResultString![0]!.removeAt(index);
                                    fileUrlFromFirestoreList![0]!
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
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: imageUint8ListList2![1]!.isEmpty &&
                            finalFileResultString![1]!.isEmpty &&
                            fileUrlFromFirestoreList![1]!.isEmpty &&
                            imageUrlFromFirestoreList2![1]!.isEmpty
                        ? Colors.grey.shade500
                        : Colors.green.shade900,
                    size: 15.0,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.type == 'Company'
                        ? '2) หนังสือรับรองบริษัทไม่หมดอายุเกิน 6 เดือน (บังคับ)'
                        : '2) ทะเบียนบ้าน',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      imageDialog2(
                        widget.type == 'Company'
                            ? '(หนังสือรับรองบริษัทไม่หมดอายุเกิน 6 เดือน)'
                            : '(ทะเบียนบ้าน)',
                        1,
                      );
                    },
                    child: Icon(
                      FFIcons.kpaperclipPlus,
                      color: Colors.black,
                      size: 15.0,
                    ),
                  ),
                ],
              ),
              for (int index = 0;
                  index < finalFileResultString![1]!.length;
                  index++)
                finalFileResultString![1]![index].isNotEmpty
                    ? Container(
                        color: null,
                        width: 600,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                // if (!await launchURL(
                                //     finalFileResultString![
                                //         1]![index])) {
                                //   throw Exception(
                                //       'Could not launch ${finalFileResultString![1]![index]}');
                                // }

                                OpenFile.open(
                                    finalFileResultString![1]![index]);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '- ไฟล์ที่ ${index + 1}',
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.search,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    finalFileResultString![1]!.removeAt(index);
                                    fileUrlFromFirestoreList![1]!
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
                      )
                    : Container(
                        color: null,
                        width: 600,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (!await launchURL(
                                    fileUrlFromFirestoreList![1]![index])) {
                                  throw Exception(
                                      'Could not launch ${fileUrlFromFirestoreList![1]![index]}');
                                }

                                // OpenFile.open(
                                //     finalFileResultString![
                                //         4]![index]);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '- ไฟล์ที่ ${index + 1}',
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.search,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    finalFileResultString![1]!.removeAt(index);

                                    fileUrlFromFirestoreList![1]!
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
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: imageUint8ListList2![2]!.isEmpty &&
                            finalFileResultString![2]!.isEmpty &&
                            fileUrlFromFirestoreList![2]!.isEmpty &&
                            imageUrlFromFirestoreList2![2]!.isEmpty
                        ? Colors.grey.shade500
                        : Colors.green.shade900,
                    size: 15.0,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.type == 'Company'
                        ? _model.radioButtonValueControllerVat!.value == 'มี'
                            ? '3) ภพ.20 (บังคับ)'
                            : '3) ภพ.20'
                        : '3) แผนที่ในการจัดส่งสินค้า',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      imageDialog2(
                        widget.type == 'Company'
                            ? '(ภพ.20)'
                            : '(แผนที่ในการจัดส่งสินค้า)',
                        2,
                      );
                    },
                    child: Icon(
                      FFIcons.kpaperclipPlus,
                      color: Colors.black,
                      size: 15.0,
                    ),
                  ),
                ],
              ),
              for (int index = 0;
                  index < finalFileResultString![2]!.length;
                  index++)
                finalFileResultString![2]![index].isNotEmpty
                    ? Container(
                        color: null,
                        width: 600,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                // if (!await launchURL(
                                //     finalFileResultString![
                                //         2]![index])) {
                                //   throw Exception(
                                //       'Could not launch ${finalFileResultString![2]![index]}');
                                // }

                                OpenFile.open(
                                    finalFileResultString![2]![index]);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '- ไฟล์ที่ ${index + 1}',
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.search,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    finalFileResultString![2]!.removeAt(index);
                                    fileUrlFromFirestoreList![2]!
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
                      )
                    : Container(
                        color: null,
                        width: 600,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (!await launchURL(
                                    fileUrlFromFirestoreList![2]![index])) {
                                  throw Exception(
                                      'Could not launch ${fileUrlFromFirestoreList![2]![index]}');
                                }

                                // OpenFile.open(
                                //     finalFileResultString![
                                //         4]![index]);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '- ไฟล์ที่ ${index + 1}',
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.search,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    finalFileResultString![2]!.removeAt(index);

                                    fileUrlFromFirestoreList![2]!
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
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: imageUint8ListList2![3]!.isEmpty &&
                            finalFileResultString![3]!.isEmpty &&
                            fileUrlFromFirestoreList![3]!.isEmpty &&
                            imageUrlFromFirestoreList2![3]!.isEmpty
                        ? Colors.grey.shade500
                        : Colors.green.shade900,
                    size: 15.0,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.type == 'Company'
                        ? '4) แผนที่ในการจัดส่งสินค้า'
                        : '4) เอกสารอื่นๆ',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      imageDialog2(
                        widget.type == 'Company'
                            ? '(แผนที่ในการจัดส่งสินค้า)'
                            : '(เอกสารอื่นๆ)',
                        3,
                      );
                    },
                    child: Icon(
                      FFIcons.kpaperclipPlus,
                      color: Colors.black,
                      size: 15.0,
                    ),
                  ),
                ],
              ),
              for (int index = 0;
                  index < finalFileResultString![3]!.length;
                  index++)
                finalFileResultString![3]![index].isNotEmpty
                    ? Container(
                        color: null,
                        width: 600,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                // if (!await launchURL(
                                //     finalFileResultString![
                                //         3]![index])) {
                                //   throw Exception(
                                //       'Could not launch ${finalFileResultString![3]![index]}');
                                // }

                                OpenFile.open(
                                    finalFileResultString![3]![index]);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '- ไฟล์ที่ ${index + 1}',
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.search,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    finalFileResultString![3]!.removeAt(index);
                                    fileUrlFromFirestoreList![3]!
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
                      )
                    : Container(
                        color: null,
                        width: 600,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (!await launchURL(
                                    fileUrlFromFirestoreList![3]![index])) {
                                  throw Exception(
                                      'Could not launch ${fileUrlFromFirestoreList![3]![index]}');
                                }

                                // OpenFile.open(
                                //     finalFileResultString![
                                //         4]![index]);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '- ไฟล์ที่ ${index + 1}',
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.search,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    finalFileResultString![3]!.removeAt(index);
                                    fileUrlFromFirestoreList![3]!
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
          ),
          widget.type == 'Company'
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: imageUint8ListList2![4]!.isEmpty &&
                                  finalFileResultString![4]!.isEmpty &&
                                  fileUrlFromFirestoreList![4]!.isEmpty &&
                                  imageUrlFromFirestoreList2![4]!.isEmpty
                              ? Colors.grey.shade500
                              : Colors.green.shade900,
                          size: 15.0,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '5) เอกสารอื่นๆ',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            imageDialog2(
                              '(เอกสารอื่นๆ)',
                              4,
                            );
                          },
                          child: Icon(
                            FFIcons.kpaperclipPlus,
                            color: Colors.black,
                            size: 15.0,
                          ),
                        ),
                      ],
                    ),
                    for (int index = 0;
                        index < finalFileResultString![4]!.length;
                        index++)
                      finalFileResultString![4]![index].isNotEmpty
                          ? Container(
                              color: null,
                              width: 600,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      // if (!await launchURL(
                                      //     finalFileResultString![
                                      //         4]![index])) {
                                      //   throw Exception(
                                      //       'Could not launch ${finalFileResultString![4]![index]}');
                                      // }

                                      OpenFile.open(
                                          finalFileResultString![4]![index]);
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
                                  Spacer(),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          finalFileResultString![4]!
                                              .removeAt(index);
                                          fileUrlFromFirestoreList![4]!
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
                            )
                          : Container(
                              color: null,
                              width: 600,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (!await launchURL(
                                          fileUrlFromFirestoreList![4]![
                                              index])) {
                                        throw Exception(
                                            'Could not launch ${fileUrlFromFirestoreList![4]![index]}');
                                      }

                                      // OpenFile.open(
                                      //     finalFileResultString![
                                      //         4]![index]);
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
                                  Spacer(),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          finalFileResultString![4]!
                                              .removeAt(index);
                                          fileUrlFromFirestoreList![4]!
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
                )
              : SizedBox(),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 8.0, 5.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).accent3,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 10.0, 10.0, 10.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            // width: (MediaQuery.of(context).size.width * 0.63 +
                            //         (((MediaQuery.of(context).size.width * 0.63) /
                            //                 4.5) *
                            //             (imageUint8ListList2![0]!.length -
                            //                 2))) +
                            //     (MediaQuery.of(context).size.width * 0.63 +
                            //         (((MediaQuery.of(context).size.width * 0.63) /
                            //                 4.5) *
                            //             (imageUint8ListList2![1]!.length -
                            //                 2))) +
                            //     (MediaQuery.of(context).size.width * 0.63 +
                            //         (((MediaQuery.of(context).size.width * 0.63) /
                            //                 4.5) *
                            //             (imageUint8ListList2![2]!.length -
                            //                 2))) +
                            //     (MediaQuery.of(context).size.width * 0.63 +
                            //         (((MediaQuery.of(context).size.width * 0.63) /
                            //                 4.5) *
                            //             (imageUint8ListList2![3]!.length -
                            //                 2))) +
                            //     (MediaQuery.of(context).size.width * 0.63 +
                            //         (((MediaQuery.of(context).size.width *
                            //                     0.63) /
                            //                 4.5) *
                            //             (imageUint8ListList2![4]!.length - 2))),
                            height: 100,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ListView.builder(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: imageUint8ListList2![0]!.length,
                                  itemBuilder: (context, index) {
                                    return imageUint8ListList2![0]![index] !=
                                            null
                                        ? Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        showPreviewImage2(
                                                      index,
                                                      'memory',
                                                      0,
                                                    ),
                                                    // child: Image
                                                    //     .memory(
                                                    //   imageUint8ListList2![0]![
                                                    //       index]!,
                                                    child: Image.memory(
                                                      imageUint8ListList2![0]![
                                                          index]!,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          '${index + 1}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize: (lang ==
                                                              //         'my')
                                                              //     ? 10
                                                              //     : 10),
                                                              fontSize: 10),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                        onTap: () {
                                                          //==========================================
                                                          imageUrlFromFirestoreList2![
                                                                  0]!
                                                              .removeAt(index);
                                                          imageUint8ListList2![
                                                                  0]!
                                                              .removeAt(index);
                                                          imageFileList2![0]!
                                                              .removeAt(index);
                                                          imageList2![0]!
                                                              .removeAt(index);

                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        showPreviewImage2(
                                                      index,
                                                      'network',
                                                      0,
                                                    ),
                                                    // child: Image
                                                    //     .memory(
                                                    //   imageUint8ListList2![0]![
                                                    //       index]!,
                                                    child: Image.network(
                                                      imageUrlFromFirestoreList2![
                                                          0]![index],
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          '${index + 1}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize: (lang ==
                                                              //         'my')
                                                              //     ? 10
                                                              //     : 10),
                                                              fontSize: 10),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                        onTap: () {
                                                          //==========================================
                                                          print(
                                                              imageUrlFromFirestoreList2![
                                                                  0]);
                                                          imageUrlFromFirestoreList2![
                                                                  0]!
                                                              .removeAt(index);
                                                          imageUint8ListList2![
                                                                  0]!
                                                              .removeAt(index);
                                                          imageFileList2![0]!
                                                              .removeAt(index);
                                                          imageList2![0]!
                                                              .removeAt(index);

                                                          setState(() {});
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
                                ListView.builder(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: imageUint8ListList2![1]!.length,
                                  itemBuilder: (context, index) {
                                    return imageUint8ListList2![1]![index] !=
                                            null
                                        ? Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        showPreviewImage2(
                                                      index,
                                                      'memory',
                                                      1,
                                                    ),
                                                    // child: Image
                                                    //     .memory(
                                                    //   imageUint8ListList2![0]![
                                                    //       index]!,
                                                    child: Image.memory(
                                                      imageUint8ListList2![1]![
                                                          index]!,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          '${index + 1 + imageUint8ListList2![0]!.length}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize: (lang ==
                                                              //         'my')
                                                              //     ? 10
                                                              //     : 10),
                                                              fontSize: 10),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                        onTap: () {
                                                          //==========================================
                                                          imageUrlFromFirestoreList2![
                                                                  1]!
                                                              .removeAt(index);
                                                          imageUint8ListList2![
                                                                  1]!
                                                              .removeAt(index);
                                                          imageFileList2![1]!
                                                              .removeAt(index);
                                                          imageList2![1]!
                                                              .removeAt(index);

                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        showPreviewImage2(
                                                      index,
                                                      'network',
                                                      1,
                                                    ),
                                                    child: Image.network(
                                                      imageUrlFromFirestoreList2![
                                                          1]![index],
                                                      // child: Image
                                                      //     .memory(
                                                      //   imageUint8ListList2![1]![
                                                      //       index]!,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          '${index + 1 + imageUint8ListList2![0]!.length}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize: (lang ==
                                                              //         'my')
                                                              //     ? 10
                                                              //     : 10),
                                                              fontSize: 10),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                        onTap: () {
                                                          //==========================================
                                                          imageUrlFromFirestoreList2![
                                                                  1]!
                                                              .removeAt(index);
                                                          imageUint8ListList2![
                                                                  1]!
                                                              .removeAt(index);
                                                          imageFileList2![1]!
                                                              .removeAt(index);
                                                          imageList2![1]!
                                                              .removeAt(index);

                                                          setState(() {});
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
                                ListView.builder(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: imageUint8ListList2![2]!.length,
                                  itemBuilder: (context, index) {
                                    return imageUint8ListList2![2]![index] !=
                                            null
                                        ? Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        showPreviewImage2(
                                                      index,
                                                      'memory',
                                                      2,
                                                    ),
                                                    // child: Image
                                                    //     .memory(
                                                    //   imageUint8ListList2![0]![
                                                    //       index]!,
                                                    child: Image.memory(
                                                      imageUint8ListList2![2]![
                                                          index]!,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          '${index + 1 + imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize: (lang ==
                                                              //         'my')
                                                              //     ? 10
                                                              //     : 10),
                                                              fontSize: 10),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                        onTap: () {
                                                          //==========================================
                                                          imageUrlFromFirestoreList2![
                                                                  2]!
                                                              .removeAt(index);
                                                          imageUint8ListList2![
                                                                  2]!
                                                              .removeAt(index);
                                                          imageFileList2![2]!
                                                              .removeAt(index);
                                                          imageList2![2]!
                                                              .removeAt(index);

                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        showPreviewImage2(index,
                                                            'network', 2),
                                                    child: Image.network(
                                                      imageUrlFromFirestoreList2![
                                                          2]![index],
                                                      // child: Image
                                                      //     .memory(
                                                      //   imageUint8ListList2![2]![
                                                      //       index]!,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          '${index + 1 + imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize: (lang ==
                                                              //         'my')
                                                              //     ? 10
                                                              //     : 10),
                                                              fontSize: 10),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                        onTap: () {
                                                          //==========================================
                                                          imageUrlFromFirestoreList2![
                                                                  2]!
                                                              .removeAt(index);
                                                          imageUint8ListList2![
                                                                  2]!
                                                              .removeAt(index);
                                                          imageFileList2![2]!
                                                              .removeAt(index);
                                                          imageList2![2]!
                                                              .removeAt(index);
                                                          setState(() {});
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
                                ListView.builder(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: imageUint8ListList2![3]!.length,
                                  itemBuilder: (context, index) {
                                    return imageUint8ListList2![3]![index] !=
                                            null
                                        ? Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        showPreviewImage2(
                                                      index,
                                                      'memory',
                                                      3,
                                                    ),
                                                    // child: Image
                                                    //     .memory(
                                                    //   imageUint8ListList2![0]![
                                                    //       index]!,
                                                    child: Image.memory(
                                                      imageUint8ListList2![3]![
                                                          index]!,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          '${index + 1 + imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize: (lang ==
                                                              //         'my')
                                                              //     ? 10
                                                              //     : 10),
                                                              fontSize: 10),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                        onTap: () {
                                                          //==========================================
                                                          imageUrlFromFirestoreList2![
                                                                  3]!
                                                              .removeAt(index);
                                                          imageUint8ListList2![
                                                                  3]!
                                                              .removeAt(index);
                                                          imageFileList2![3]!
                                                              .removeAt(index);
                                                          imageList2![3]!
                                                              .removeAt(index);

                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        showPreviewImage2(index,
                                                            'network', 3),
                                                    child: Image.network(
                                                      imageUrlFromFirestoreList2![
                                                          3]![index],
                                                      // child: Image
                                                      //     .memory(
                                                      //   imageUint8ListList2![3]![
                                                      //       index]!,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          '${index + 1 + imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize: (lang ==
                                                              //         'my')
                                                              //     ? 10
                                                              //     : 10),
                                                              fontSize: 10),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                        onTap: () {
                                                          //==========================================
                                                          imageUrlFromFirestoreList2![
                                                                  3]!
                                                              .removeAt(index);
                                                          imageUint8ListList2![
                                                                  3]!
                                                              .removeAt(index);
                                                          imageFileList2![3]!
                                                              .removeAt(index);
                                                          imageList2![3]!
                                                              .removeAt(index);
                                                          setState(() {});
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
                                ListView.builder(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: imageUint8ListList2![4]!.length,
                                  itemBuilder: (context, index) {
                                    return imageUint8ListList2![4]![index] !=
                                            null
                                        ? Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        showPreviewImage2(
                                                      index,
                                                      'memory',
                                                      4,
                                                    ),
                                                    // child: Image
                                                    //     .memory(
                                                    //   imageUint8ListList2![0]![
                                                    //       index]!,
                                                    child: Image.memory(
                                                      imageUint8ListList2![4]![
                                                          index]!,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          '${index + 1 + imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize: (lang ==
                                                              //         'my')
                                                              //     ? 10
                                                              //     : 10),
                                                              fontSize: 10),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                        onTap: () {
                                                          //==========================================
                                                          imageUrlFromFirestoreList2![
                                                                  4]!
                                                              .removeAt(index);
                                                          imageUint8ListList2![
                                                                  4]!
                                                              .removeAt(index);
                                                          imageFileList2![4]!
                                                              .removeAt(index);
                                                          imageList2![4]!
                                                              .removeAt(index);

                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        showPreviewImage2(index,
                                                            'network', 4),
                                                    child: Image.network(
                                                      imageUrlFromFirestoreList2![
                                                          4]![index],
                                                      // child: Image
                                                      //     .memory(
                                                      //   imageUint8ListList2![4]![
                                                      //       index]!,
                                                      width: (MediaQuery.of(
                                                                      context)
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
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          '${index + 1 + imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize: (lang ==
                                                              //         'my')
                                                              //     ? 10
                                                              //     : 10),
                                                              fontSize: 10),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                        onTap: () {
                                                          //==========================================
                                                          imageUrlFromFirestoreList2![
                                                                  4]!
                                                              .removeAt(index);
                                                          imageUint8ListList2![
                                                                  4]!
                                                              .removeAt(index);
                                                          imageFileList2![4]!
                                                              .removeAt(index);
                                                          imageList2![4]!
                                                              .removeAt(index);
                                                          setState(() {});
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

                                //=======================================
                                for (int i = imageUint8ListList2![0]!.length +
                                        imageUint8ListList2![1]!.length +
                                        imageUint8ListList2![2]!.length +
                                        imageUint8ListList2![3]!.length +
                                        imageUint8ListList2![4]!.length;
                                    i < 6;
                                    i++)
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5.0, 0.0, 6.0, 0.0),
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  0.63) /
                                              4.5,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      child: Icon(
                                        FFIcons.kimagePlus,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 40.0,
                                      ),
                                    ),
                                  ),
                                //=======================================
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
          ),
        ],
      ),
    );
  }

  StatefulBuilder idCustomerGroupFiveEdit() {
    return StatefulBuilder(builder: (context, setStateFive) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
        child: FlutterFlowDropDown<String>(
          controller: _model.dropDownValueController185 ??=
              FormFieldController<String>(null),
          options: dropdownGroup5,
          onChanged: (val) {
            // scrollDown();

            setStateFive(() {
              if (val == 'ยกเลิก') {
                _model.dropDownValue185 = val;
                _model.dropDownValueController185!.reset();
              }
            });
          },
          // onChanged: (val) => setState(() => _model.dropDownValue185 = val),
          height: 55.0,
          textStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'รหัสกลุ่มลูกค้า กลุ่ม 5',
          icon: Icon(
            Icons.arrow_left_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          elevation: 2.0,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2.0,
          borderRadius: 8.0,
          margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
          hidesUnderline: true,
          isSearchable: false,
          isMultiSelect: false,
        ),
      );
    });
  }

  StatefulBuilder idCustomerGroupFourEdit() {
    return StatefulBuilder(builder: (context, setStateFour) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
        child: FlutterFlowDropDown<String>(
          controller: _model.dropDownValueController184 ??=
              FormFieldController<String>(null),
          options: dropdownGroup4,
          onChanged: (val) {
            // scrollDown();

            setStateFour(() {
              if (val == 'ยกเลิก') {
                _model.dropDownValue184 = val;
                _model.dropDownValueController184!.reset();
              }
            });
          },
          // onChanged: (val) => setState(() => _model.dropDownValue184 = val),
          height: 55.0,
          textStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'รหัสกลุ่มลูกค้า กลุ่ม 4',
          icon: Icon(
            Icons.arrow_left_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          elevation: 2.0,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2.0,
          borderRadius: 8.0,
          margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
          hidesUnderline: true,
          isSearchable: false,
          isMultiSelect: false,
        ),
      );
    });
  }

  StatefulBuilder idCustomerGroupThreeEdit() {
    return StatefulBuilder(builder: (context, setStateMove) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
        child: FlutterFlowDropDown<String>(
          controller: _model.dropDownValueController183 ??=
              FormFieldController<String>(null),
          options: dropdownGroup3, // Scroll ด้านล่างสุด

          onChanged: (val) async {
            // scrollDown();

            setStateMove(() {
              _model.dropDownValue183 = val;
              if (val == 'ยกเลิก') {
                _model.dropDownValueController183!.reset();
              }
            });
          },

          // onChanged: (val) => setState(() => _model.dropDownValue183 = val),
          height: 55.0,
          textStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'รหัสกลุ่มลูกค้า กลุ่ม 3',
          icon: Icon(
            Icons.arrow_left_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          elevation: 2.0,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2.0,
          borderRadius: 8.0,
          margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
          hidesUnderline: true,
          isSearchable: false,
          isMultiSelect: false,
        ),
      );
    });
  }

  StatefulBuilder idCustomerGroupTwoEdit() {
    return StatefulBuilder(builder: (context, setStateTwo) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
        child: FlutterFlowDropDown<String>(
          controller: _model.dropDownValueController182 ??=
              FormFieldController<String>(null),
          options: dropdownGroup2,
          onChanged: (val) {
            // scrollDown();

            setStateTwo(() {
              _model.dropDownValue182 = val;
              if (val == 'ยกเลิก') {
                _model.dropDownValueController182!.reset();
              }
            });
          },
          height: 55.0,
          textStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'รหัสกลุ่มลูกค้า กลุ่ม 2',
          icon: Icon(
            Icons.arrow_left_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          elevation: 2.0,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2.0,
          borderRadius: 8.0,
          margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
          hidesUnderline: true,
          isSearchable: false,
          isMultiSelect: false,
        ),
      );
    });
  }

  StatefulBuilder idCustmerGroupOneEdit() {
    return StatefulBuilder(builder: (context, setStateOne) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
        child: FlutterFlowDropDown<String>(
          controller: _model.dropDownValueController18 ??=
              FormFieldController<String>(null),
          options: dropdownGroup1,
          // onChanged: (val) => setState(() => _model.dropDownValue18 = val),
          onChanged: (val) {
            // scrollDown();
            // setStateOne(() => _model.dropDownValue18 = val);
            setStateOne(() {
              _model.dropDownValue18 = val == 'ยกเลิก' ? null : val;
              if (val == 'ยกเลิก') {
                _model.dropDownValueController18!.reset();
              }
            });
          },
          height: 55.0,
          textStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'รหัสกลุ่มลูกค้า กลุ่ม 1',
          icon: Icon(
            Icons.arrow_left_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          elevation: 2.0,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2.0,
          borderRadius: 8.0,
          margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
          hidesUnderline: true,
          isSearchable: false,
          isMultiSelect: false,
        ),
      );
    });
  }

  Padding nameEmployeeEdit(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
      child: IgnorePointer(
        child: TextFormField(
          readOnly: true,
          // controller: _model.textController1Company,
          // focusNode: _model.textFieldFocusNode1Company,
          autofocus: false,
          obscureText: false,
          decoration: InputDecoration(
            label: Text(widget.entryMap!['value']['ชื่อพนักงานขาย']),
            // labelText: 'ชื่อบริษัn',
            isDense: true,
            labelStyle: FlutterFlowTheme.of(context).labelMedium,
            hintText: widget.entryMap!['value']['ชื่อพนักงานขาย'],
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
          // validator: _model.textController1Validator
          //     .asValidator(context),
        ),
      ),
    );
  }

  Padding idCustmerEdit(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
      child: IgnorePointer(
        child: TextFormField(
          readOnly: true,
          // controller: _model.textController1Company,
          // focusNode: _model.textFieldFocusNode1Company,
          autofocus: false,
          obscureText: false,
          decoration: InputDecoration(
            label: Text(widget.entryMap!['value']['รหัสพนักงานขาย']),
            // labelText: 'ชื่อบริษัn',
            isDense: true,
            labelStyle: FlutterFlowTheme.of(context).labelMedium,
            hintText: widget.entryMap!['value']['รหัสพนักงานขาย'],
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
          // validator: _model.textController1Validator
          //     .asValidator(context),
        ),
      ),
    );
  }

  StatefulBuilder idAccoutingEdit() {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
        child: FlutterFlowDropDown<String>(
          controller: _model.dropDownValueController15 ??=
              FormFieldController<String>(null),
          options: dropdown5,
          onChanged: (val) => setState(() => _model.dropDownValue15 = val),
          height: 55.0,
          textStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'รหัสบัญชี (MFOOD API)',
          icon: Icon(
            Icons.arrow_left_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          elevation: 2.0,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2.0,
          borderRadius: 8.0,
          margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
          hidesUnderline: true,
          isSearchable: false,
          isMultiSelect: false,
        ),
      );
    });
  }

  StatefulBuilder departmentEdit() {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
        child: FlutterFlowDropDown<String>(
          controller: _model.dropDownValueController14 ??=
              FormFieldController<String>(null),
          options: dropdown4,
          onChanged: (val) => setState(() => _model.dropDownValue14 = val),
          height: 55.0,
          textStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'แผนก (MFOOD API)',
          icon: Icon(
            Icons.arrow_left_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          elevation: 2.0,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2.0,
          borderRadius: 8.0,
          margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
          hidesUnderline: true,
          isSearchable: false,
          isMultiSelect: false,
        ),
      );
    });
  }

  StatefulBuilder bookBankEdit() {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
        child: FlutterFlowDropDown<String>(
          controller: _model.dropDownValueController13 ??=
              FormFieldController<String>(null),
          options: dropdown3,
          onChanged: (val) => setState(() => _model.dropDownValue13 = val),
          height: 55.0,
          textStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'เลือกบัญชีธนาคารของบริษัท (MFOOD API)',
          icon: Icon(
            Icons.arrow_left_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          elevation: 2.0,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2.0,
          borderRadius: 8.0,
          margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
          hidesUnderline: true,
          isSearchable: false,
          isMultiSelect: false,
        ),
      );
    });
  }

  StatefulBuilder payChooseEdit(Map<String, dynamic> dataPay) {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
        child: FlutterFlowDropDown<String>(
          controller: _model.dropDownValueController12 ??=
              FormFieldController<String>(null),
          // options: ['มัดจำ 50%', 'มัดจำ 60%', 'มัดจำ 70%'],
          options: dropdownPay,
          onChanged: (val) {
            _model.dropDownValue12 = val;

            Map<String, dynamic>? foundMapData;
            dataPay.forEach((key, value) {
              if (value["PTERM_DESC"] == val) {
                foundMapData = value;
              }
            });

            if (foundMapData! != null) {
              print("Found Map: $foundMapData");
              _model.textController191.text = foundMapData!['PCREDIT_DAY'];
            } else {
              print("ไม่พบ map ที่มี PTERM_DESC เป็น $val");
            }
            setState(() {});
          },
          height: 55.0,
          textStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'เงื่อนไขการชำระเงิน (Dropdown จาก API)',
          icon: Icon(
            Icons.arrow_left_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          elevation: 2.0,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2.0,
          borderRadius: 8.0,
          margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
          hidesUnderline: true,
          isSearchable: false,
          isMultiSelect: false,
        ),
      );
    });
  }

  StatefulBuilder payOptionEditDropdown() {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
        child: FlutterFlowDropDown<String>(
          controller: _model.dropDownValueController11 ??=
              FormFieldController<String>(null),
          options: dropdown2,
          //  [
          //   'เงินสด',
          //   'โอนผ่านบัญชี',
          //   'Gb Pay'
          // ],
          onChanged: (val) {
            // scrollDown();
            setState(() => _model.dropDownValue11 = val);
          },
          height: 55.0,
          textStyle: FlutterFlowTheme.of(context).bodyMedium,
          hintText: 'ประเภทการจ่ายเงิน (Dropdown จาก API)',
          icon: Icon(
            Icons.arrow_left_outlined,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 24.0,
          ),
          elevation: 2.0,
          borderColor: FlutterFlowTheme.of(context).alternate,
          borderWidth: 2.0,
          borderRadius: 8.0,
          margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
          hidesUnderline: true,
          isSearchable: false,
          isMultiSelect: false,
        ),
      );
    });
  }

  Padding billDiscountEdit(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: TextFormField(
        controller: _model.textController20,
        focusNode: _model.textFieldFocusNode20,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          labelText: 'ส่วนลดท้ายบิล (จำนวนบาท หรือ x%)',
          hintText: 'ส่วนลดท้ายบิล (จำนวนบาท หรือ x%)',
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
        validator: _model.textController20Validator.asValidator(context),
      ),
    );
  }

  Padding creditPayEdit(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: TextFormField(
        controller: _model.textController19,
        // focusNode: _model.textFieldFocusNode19,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          labelText:
              'วงเงินเครดิต (กรณีไม่มีการกำหนดเครดิตให้ใสเป็น 0 ค่าเริ่มต้น',
          hintText:
              'วงเงินเครดิต (กรณีไม่มีการกำหนดเครดิตให้ใสเป็น 0 ค่าเริ่มต้น',
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
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        textAlign: TextAlign.start,
        // validator: _model.textController19Validator.asValidator(context),
      ),
    );
  }

  Padding payOptionEdit() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: TextFormField(
        controller: _model.textController191,
        // focusNode: _model.textFieldFocusNode191,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          labelText: 'ระยะเวลาชำระหนี้',
          hintText: 'ระยะเวลาชำระหนี้',
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
        // validator: _model.textController19Validator1.asValidator(context),
      ),
    );
  }

  StatefulBuilder addressToBillAndSendChooseEdit() {
    return StatefulBuilder(
      builder: (context, setState) {
        print(total4);
        print(resultListSendAndBill.length);

        if (resultListSendAndBill.length == total4) {
        } else {
          for (int i = resultListSendAndBill.length; i < total4; i++) {
            print(total4);
            print(i);
            resultListSendAndBill.add({
              'ที่อยู่จัดส่ง': '',
              'ชื่อออกบิล': '',
              'ที่อยู่ออกบิล': '',
              'ที่อยู่จัดส่งID': '',
              'ที่อยู่ออกบิลID': '',
            });

            dropDownControllersSend.add(FormFieldController<String>(''));
            dropDownControllersBill.add(FormFieldController<String>(''));

            sendAndBillList!.add(TextEditingController());

            textFieldFocusSendAndBill!.add(FocusNode());
          }
        }

        return Column(
          children: [
            for (int index = 0; index < total4; index++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        '  กำหนดที่อยู่ในการจัดส่งและออกบิล ลำดับที่ ${index + 1}',
                        style: FlutterFlowTheme.of(context).labelLarge,
                      ),
                      total4 == 1
                          ? SizedBox()
                          : index + 1 == total4
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    right: 5.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      total4 = total4 - 1;
                                      resultListSendAndBill.removeLast();

                                      dropDownControllersSend.removeLast();

                                      dropDownControllersBill.removeLast();

                                      sendAndBillList!.removeLast();

                                      textFieldFocusSendAndBill!.removeLast();
                                    }),
                                    child: Icon(
                                      Icons.remove_circle_outline_outlined,
                                      size: 12,
                                      color: Colors.red.shade900,
                                    ),
                                  ),
                                )
                              : SizedBox()
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          ' กำหนดที่อยู่ในการจัดส่ง ',
                          style: FlutterFlowTheme.of(context).bodySmall,
                        ),
                      ],
                    ),
                  ), //======================= กำหนดที่อยูในการจัดส่ง ======================================
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                    child: FlutterFlowDropDown<String>(
                      controller: dropDownControllersSend[index],
                      options: addressAllForDropdown,
                      // options: resultList
                      //     .map((item) =>
                      //         item['รหัสสาขา'].toString() +
                      //         (' ') +
                      //         item['ชื่อสาขา'].toString() +
                      //         (' ') +
                      //         item['HouseNumber'].toString() +
                      //         (' ') +
                      //         item['VillageName'].toString() +
                      //         (' ') +
                      //         item['Road'].toString() +
                      //         (' ') +
                      //         item['Province'].toString() +
                      //         (' ') +
                      //         item['District'].toString() +
                      //         (' ') +
                      //         item['SubDistrict'].toString() +
                      //         (' ') +
                      //         item['PostalCode'].toString() +
                      //         (' ') +
                      //         item['ผู้ติดต่อ'].toString() +
                      //         (' ') +
                      //         item['ตำแหน่ง'].toString() +
                      //         (' ') +
                      //         item['โทรศัพท์'].toString())
                      //     .toList(),
                      onChanged: (val) => setState(() {
                        // dropDownControllersSendID[index] =
                        print('in ที่อยู่');
                        print(dropDownControllersBill[index].value);
                        resultListSendAndBill[index]['ที่อยู่จัดส่ง'] = val;
                        if (dropDownControllersBill[index].value == '') {
                          dropDownControllersBill[index].value = val;
                          resultListSendAndBill[index]['ที่อยู่ออกบิล'] = val;
                        }

                        print(index);
                        print(resultListSendAndBill[index]['ที่อยู่จัดส่ง']);
                      }),
                      height: 55.0,
                      textStyle: FlutterFlowTheme.of(context).bodyMedium,
                      hintText: 'ที่อยู่',
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
                          EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                      hidesUnderline: true,
                      isSearchable: false,
                      isMultiSelect: false,
                    ),
                  ),
                  //========================  หัวข้อ กำหนดที่อยูในการออกบิล =====================================
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          ' ที่อยู่ในการออกใบกำกับภาษี',
                          style: FlutterFlowTheme.of(context).bodySmall,
                        ),
                      ],
                    ),
                  ),
                  //======================== ที่อยู่ กำหนดที่อยูในการออกบิล =====================================
                  // Padding(
                  //   padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                  //   child: TextFormField(
                  //     controller: sendAndBillList![index],

                  //     // controller: _model.textController15,
                  //     focusNode: textFieldFocusSendAndBill![index],
                  //     autofocus: false,
                  //     obscureText: false,
                  //     decoration: InputDecoration(
                  //       isDense: true,
                  //       labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  //       labelText: 'ชื่อจ่าหน้าที่อยู่ในการออกบิล',
                  //       hintText: 'ชื่อจ่าหน้าที่อยู่ในการออกบิล',
                  //       hintStyle: FlutterFlowTheme.of(context).labelMedium,
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: FlutterFlowTheme.of(context).alternate,
                  //           width: 2.0,
                  //         ),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: FlutterFlowTheme.of(context).primary,
                  //           width: 2.0,
                  //         ),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //       ),
                  //       errorBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: FlutterFlowTheme.of(context).error,
                  //           width: 2.0,
                  //         ),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //       ),
                  //       focusedErrorBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: FlutterFlowTheme.of(context).error,
                  //           width: 2.0,
                  //         ),
                  //         borderRadius: BorderRadius.circular(8.0),
                  //       ),
                  //     ),
                  //     style: FlutterFlowTheme.of(context).bodyMedium,
                  //     textAlign: TextAlign.start,
                  //     // validator: _model.textController19Validator
                  //     //     .asValidator(context),
                  //   ),
                  // ),

                  //========================= ไวก่อน ====================================
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                    child: FlutterFlowDropDown<String>(
                      controller: dropDownControllersBill[index],
                      options: addressAllForDropdown,

// ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}

                      // options: resultList
                      //     .map((item) =>
                      //         item['รหัสสาขา'].toString() +
                      //         (' ') +
                      //         item['ชื่อสาขา'].toString() +
                      //         (' ') +
                      //         item['HouseNumber'].toString() +
                      //         (' ') +
                      //         item['VillageName'].toString() +
                      //         (' ') +
                      //         item['Road'].toString() +
                      //         (' ') +
                      //         item['Province'].toString() +
                      //         (' ') +
                      //         item['District'].toString() +
                      //         (' ') +
                      //         item['SubDistrict'].toString() +
                      //         (' ') +
                      //         item['PostalCode'].toString() +
                      //         (' ') +
                      //         item['ผู้ติดต่อ'].toString() +
                      //         (' ') +
                      //         item['ตำแหน่ง'].toString() +
                      //         (' ') +
                      //         item['โทรศัพท์'].toString())
                      //     .toList(),
                      //  ['ที่อยู่ 1', 'ที่อยู่ 2', 'ที่อยู่ 3'],
                      // onChanged: (val) => setState(() {
                      //   resultListSendAndBill[index]['ที่อยู่ออกบิล'] = val;
                      //   print(index);
                      //   print(resultListSendAndBill[index]['ที่อยู่ออกบิล']);
                      // }
                      // ),

                      onChanged: (val) {
                        setState(() {
                          // if (val !=
                          //     resultListSendAndBill[index]['ที่อยู่ออกบิล']) {
                          resultListSendAndBill[index]['ที่อยู่ออกบิล'] = val;

                          // dropDownControllersBill[index].value = val;
                          // }
                        });
                      },
                      height: 55.0,
                      textStyle: FlutterFlowTheme.of(context).bodyMedium,
                      hintText: 'ที่อยู่',
                      // 'ถ้าเป็นที่อยูอื่นที่อยูในโปรไฟล์ลูกค้าให้เป็น Dropdown ให้เลือก ใน Dropdown แสดงรหัสสาขา',
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
                          EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                      hidesUnderline: true,
                      isSearchable: false,
                      isMultiSelect: false,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            //=============================================================
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 15.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      total4 = total4 + 1;
                    }),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'เพิ่มที่อยู่อื่นสำหรับการจัดส่ง',
                              style: FlutterFlowTheme.of(context).bodyMedium,
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
    );
  }

  Padding imageLessThreeEdit(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 8.0, 5.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.63,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).accent3,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      10.0, 10.0, 10.0, 10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        imageUrl.length >= 1
                            ? imageFile[0] == null
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                showPreviewImage(0, 'network'),
                                            child: Image.network(
                                              imageUrl[0],
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
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Text(
                                                  '${0 + 1}/${imageFile.length}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
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
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
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
                                                  imageUrlFromFirestore
                                                      .removeAt(0);
                                                  imageUint8List.removeAt(0);
                                                  imageFile.removeAt(0);
                                                  image!.removeAt(0);
                                                  imageUrl.removeAt(0);
                                                  imageLength = imageLength - 1;
                                                  imageAddressAllForDropdown
                                                      .clear();
                                                  for (int i = 0;
                                                      i < imageUrl.length;
                                                      i++) {
                                                    imageAddressAllForDropdown
                                                        .add('รูปภาพ ${i + 1}');
                                                  }
                                                  for (int i = 0;
                                                      i < resultList.length;
                                                      i++) {
                                                    resultList[i]['Image'] = '';
                                                    dropDownControllersimageAddress[
                                                            i]
                                                        .value = '';
                                                  }
                                                  setState(() {});
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
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                showPreviewImage(0, 'memory'),
                                            child: Image.memory(
                                              imageUint8List[0],
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
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Text(
                                                  '${0 + 1}/${imageFile.length}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
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
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
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
                                                  imageUrlFromFirestore
                                                      .removeAt(0);
                                                  imageUint8List.removeAt(0);
                                                  imageFile.removeAt(0);
                                                  image!.removeAt(0);
                                                  imageUrl.removeAt(0);
                                                  imageLength = imageLength - 1;
                                                  imageAddressAllForDropdown
                                                      .clear();
                                                  for (int i = 0;
                                                      i < imageUrl.length;
                                                      i++) {
                                                    imageAddressAllForDropdown
                                                        .add('รูปภาพ ${i + 1}');
                                                  }
                                                  for (int i = 0;
                                                      i < resultList.length;
                                                      i++) {
                                                    resultList[i]['Image'] = '';
                                                    dropDownControllersimageAddress[
                                                            i]
                                                        .value = '';
                                                  }
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                            : Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 5.0, 0.0),
                                child: Container(
                                  color: null,
                                  width: (MediaQuery.of(context).size.width *
                                          0.63) /
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
                        imageUrl.length >= 2
                            ? imageFile[1] == null
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                showPreviewImage(1, 'network'),
                                            child: Image.network(
                                              imageUrl[1],
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
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Text(
                                                  '${1 + 1}/${imageFile.length}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
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
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
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
                                                  imageUrlFromFirestore
                                                      .removeAt(1);
                                                  imageUint8List.removeAt(1);
                                                  imageFile.removeAt(1);
                                                  image!.removeAt(1);
                                                  imageUrl.removeAt(1);
                                                  imageLength = imageLength - 1;
                                                  imageAddressAllForDropdown
                                                      .clear();
                                                  for (int i = 0;
                                                      i < imageUrl.length;
                                                      i++) {
                                                    imageAddressAllForDropdown
                                                        .add('รูปภาพ ${i + 1}');
                                                  }
                                                  for (int i = 0;
                                                      i < resultList.length;
                                                      i++) {
                                                    resultList[i]['Image'] = '';
                                                    dropDownControllersimageAddress[
                                                            i]
                                                        .value = '';
                                                  }
                                                  setState(() {});
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
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                showPreviewImage(1, 'memory'),
                                            child: Image.memory(
                                              imageUint8List[1],
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
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Text(
                                                  '${1 + 1}/${imageFile.length}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
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
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
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
                                                  imageUrlFromFirestore
                                                      .removeAt(1);
                                                  imageUint8List.removeAt(1);
                                                  imageFile.removeAt(1);
                                                  image!.removeAt(1);
                                                  imageUrl.removeAt(1);
                                                  imageLength = imageLength - 1;
                                                  imageAddressAllForDropdown
                                                      .clear();
                                                  for (int i = 0;
                                                      i < imageUrl.length;
                                                      i++) {
                                                    imageAddressAllForDropdown
                                                        .add('รูปภาพ ${i + 1}');
                                                  }
                                                  for (int i = 0;
                                                      i < resultList.length;
                                                      i++) {
                                                    resultList[i]['Image'] = '';
                                                    dropDownControllersimageAddress[
                                                            i]
                                                        .value = '';
                                                  }
                                                  // imageListFile
                                                  //     .removeAt(
                                                  //         index);
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                            : Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 5.0, 0.0),
                                child: Container(
                                  width: (MediaQuery.of(context).size.width *
                                          0.63) /
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
                        imageUrl.length >= 3
                            ? imageFile[2] == null
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                showPreviewImage(2, 'network'),
                                            child: Image.network(
                                              imageUrl[2],
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
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Text(
                                                  '${2 + 1}/${imageFile.length}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
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
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
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
                                                  imageUrlFromFirestore
                                                      .removeAt(2);
                                                  imageUint8List.removeAt(2);
                                                  imageFile.removeAt(2);
                                                  image!.removeAt(2);
                                                  imageUrl.removeAt(2);
                                                  imageLength = imageLength - 1;
                                                  imageAddressAllForDropdown
                                                      .clear();
                                                  for (int i = 0;
                                                      i < imageUrl.length;
                                                      i++) {
                                                    imageAddressAllForDropdown
                                                        .add('รูปภาพ ${i + 1}');
                                                  }
                                                  for (int i = 0;
                                                      i < resultList.length;
                                                      i++) {
                                                    resultList[i]['Image'] = '';
                                                    dropDownControllersimageAddress[
                                                            i]
                                                        .value = '';
                                                  }
                                                  setState(() {});
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
                                        const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                showPreviewImage(2, 'memory'),
                                            child: Image.memory(
                                              imageUint8List[2],
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
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  bottomRight:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Text(
                                                  '${2 + 1}/${imageFile.length}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
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
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
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
                                                  imageUrlFromFirestore
                                                      .removeAt(2);
                                                  imageUint8List.removeAt(2);
                                                  imageFile.removeAt(2);
                                                  image!.removeAt(2);
                                                  imageUrl.removeAt(2);
                                                  imageLength = imageLength - 1;
                                                  imageAddressAllForDropdown
                                                      .clear();
                                                  for (int i = 0;
                                                      i < imageUrl.length;
                                                      i++) {
                                                    imageAddressAllForDropdown
                                                        .add('รูปภาพ ${i + 1}');
                                                  }
                                                  for (int i = 0;
                                                      i < resultList.length;
                                                      i++) {
                                                    resultList[i]['Image'] = '';
                                                    dropDownControllersimageAddress[
                                                            i]
                                                        .value = '';
                                                  }
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                            : Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 6.0, 0.0),
                                child: Container(
                                  width: (MediaQuery.of(context).size.width *
                                          0.63) /
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
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 0.0, 5.0, 0.0),
                          child: InkWell(
                            onTap: () {
                              imageDialog();
                              // showQucikAlert(
                              //     context);
                            },
                            child: Container(
                              width:
                                  (MediaQuery.of(context).size.width * 0.63) /
                                      4.5,
                              height: 100.0,
                              decoration: BoxDecoration(
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
                                      FFIcons.kpaperclipPlus,
                                      color: FlutterFlowTheme.of(context)
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
    );
  }

  Padding imageMoreThreeEdit(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: const AlignmentDirectional(0.00, 0.00),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 8.0, 5.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).accent3,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      10.0, 10.0, 10.0, 10.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      color: null,
                      // width: MediaQuery.of(context).size.width * 0.63 +
                      //     (((MediaQuery.of(context).size.width * 0.63) / 4.5) *
                      //         (imageUrl.length - 2)),
                      height: 100,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ListView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: imageUint8List.length,
                            itemBuilder: (context, index) {
                              return imageFile[index] == null
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () => showPreviewImage(
                                                  index, 'network'),
                                              child: Image.network(
                                                imageUrl[index],
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
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    bottomRight:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2),
                                                  child: Text(
                                                    '${index + 1}/${imageFile.length}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
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
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
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
                                                    imageUrlFromFirestore
                                                        .removeAt(index);
                                                    imageUint8List
                                                        .removeAt(index);
                                                    imageFile.removeAt(index);
                                                    image!.removeAt(index);
                                                    imageUrl.removeAt(index);
                                                    imageLength =
                                                        imageLength - 1;
                                                    imageAddressAllForDropdown
                                                        .clear();
                                                    for (int i = 0;
                                                        i < imageUrl.length;
                                                        i++) {
                                                      imageAddressAllForDropdown
                                                          .add(
                                                              'รูปภาพ ${i + 1}');
                                                    }
                                                    for (int i = 0;
                                                        i < resultList.length;
                                                        i++) {
                                                      resultList[i]['Image'] =
                                                          '';
                                                      dropDownControllersimageAddress[
                                                              i]
                                                          .value = '';
                                                    }
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () => showPreviewImage(
                                                  index, 'memory'),
                                              child: Image.memory(
                                                imageUint8List[index],
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.95) /
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
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    bottomRight:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2),
                                                  child: Text(
                                                    '${index + 1}/${imageFile.length}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
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
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
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
                                                    imageUrlFromFirestore
                                                        .removeAt(index);
                                                    imageUint8List
                                                        .removeAt(index);
                                                    imageFile.removeAt(index);
                                                    image!.removeAt(index);
                                                    imageUrl.removeAt(index);
                                                    imageLength =
                                                        imageLength - 1;
                                                    imageAddressAllForDropdown
                                                        .clear();
                                                    for (int i = 0;
                                                        i < imageUrl.length;
                                                        i++) {
                                                      imageAddressAllForDropdown
                                                          .add(
                                                              'รูปภาพ ${i + 1}');
                                                    }

                                                    for (int i = 0;
                                                        i < resultList.length;
                                                        i++) {
                                                      resultList[i]['Image'] =
                                                          '';
                                                      dropDownControllersimageAddress[
                                                              i]
                                                          .value = '';
                                                    }
                                                    setState(() {});
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
                              imageDialog();
                              // showQucikAlert(
                              //     context);
                            },
                            child: Container(
                              width:
                                  (MediaQuery.of(context).size.width * 0.63) /
                                      4.5,
                              height: 100.0,
                              decoration: BoxDecoration(
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
                                      FFIcons.kpaperclipPlus,
                                      color: FlutterFlowTheme.of(context)
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
    );
  }

  // Align mapEdit(BuildContext context) {
  //   double mapZoom = 14.4746;
  //   bool loadMap = false;
  //   return Align(
  //     alignment: const AlignmentDirectional(0.00, 0.00),
  //     child: Padding(
  //       padding: const EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
  //       child: Stack(
  //         children: [
  //           StatefulBuilder(builder: (context, setStateMap) {
  //             return Container(
  //               width: MediaQuery.sizeOf(context).width * 1.0,
  //               height: 500.0,
  //               decoration: BoxDecoration(
  //                 color: FlutterFlowTheme.of(context).secondaryBackground,
  //                 borderRadius: BorderRadius.circular(0.0),
  //                 shape: BoxShape.rectangle,
  //               ),
  //               child: loadMap
  //                   ? CircularLoading()
  //                   : GoogleMap(
  //                       onTap: (argument) async {
  //                         await mapDialog(resultList, null)
  //                             .whenComplete(() async {
  //                           if (mounted) {
  //                             setStateMap(
  //                               () {
  //                                 loadMap = true;
  //                               },
  //                             );
  //                           }
  //                           print('After Dialog Map');
  //                           print(resultList[0]['Latitude']);
  //                           late double lat;
  //                           late double lot;

  //                           if (resultList[0]['Latitude'] == '' ||
  //                               resultList[0]['Longitude'] == '') {
  //                             for (int i = 0; i < resultList.length; i++) {
  //                               if (resultList[i]['Latitude'] != '' &&
  //                                   resultList[i]['Longitude'] != '') {
  //                                 lat = double.parse(resultList[i]['Latitude']);
  //                                 lot =
  //                                     double.parse(resultList[i]['Longitude']);
  //                                 break;
  //                               } else {
  //                                 lat = 13.7563309;
  //                                 lot = 100.5017651;
  //                               }
  //                             }
  //                           } else {
  //                             lat = double.parse(resultList[0]['Latitude']);
  //                             lot = double.parse(resultList[0]['Longitude']);
  //                           }

  //                           print(lat);
  //                           print(lot);
  //                           _kGooglePlex = CameraPosition(
  //                             target: google_maps.LatLng(lat, lot),
  //                             zoom: 15,
  //                           );
  //                           markers.clear();

  //                           for (int i = 0; i < resultList.length; i++) {
  //                             if (resultList[i]['Latitude'] == '') {
  //                             } else {
  //                               double latIndex =
  //                                   double.parse(resultList[i]['Latitude']);
  //                               double lotIndex =
  //                                   double.parse(resultList[i]['Longitude']!);
  //                               print('hhhhhhhhhh');
  //                               print(resultList[i]['ID']);
  //                               // print(resultList[i]['Latitude']);
  //                               // print(resultList[i]['Longitude']);
  //                               print('hhhhhhhhhh');

  //                               markers.add(
  //                                 Marker(
  //                                   markerId: MarkerId(resultList[i]['ID']),
  //                                   position: google_maps.LatLng(
  //                                       latIndex, lotIndex), // ตำแหน่ง
  //                                   infoWindow: InfoWindow(
  //                                     title:
  //                                         'จุดที่ ${i + 1}', // ชื่อของปักหมุด
  //                                     snippet: resultList[i]['Latitude'],
  //                                     onTap: () async {
  //                                       await mapDialog(
  //                                               resultList, resultList[i]['ID'])
  //                                           .whenComplete(() {
  //                                         print('6666');
  //                                         _mapKey = GlobalKey();
  //                                         print('7777');
  //                                         if (mounted) {
  //                                           setState(() {});
  //                                         }
  //                                         print('88888');
  //                                       });
  //                                       //     .whenComplete(() {
  //                                       //   setState(
  //                                       //     () {
  //                                       //       loadMap = true;
  //                                       //     },
  //                                       //   );

  //                                       //   return;

  //                                       // });
  //                                     }, // คำอธิบายของปักหมุด
  //                                   ),
  //                                 ),
  //                               );
  //                               print('pppp');
  //                             }
  //                           }

  //                           _mapKey = GlobalKey();

  //                           print('after add map');
  //                           print(_kGooglePlex);
  //                           print(markers);

  //                           if (mounted) {
  //                             setStateMap(
  //                               () {
  //                                 loadMap = false;
  //                               },
  //                             );
  //                           }
  //                         });
  //                       },

  //                       key: _mapKey,
  //                       mapType: ui_maps.MapType.hybrid,
  //                       initialCameraPosition: _kGooglePlex,
  //                       markers: markers, // เพิ่มนี่
  //                       onMapCreated: (GoogleMapController controller) async {
  //                         mapController2.complete(controller);
  //                       },
  //                       onCameraMove: (CameraPosition position) {
  //                         mapZoom = position.zoom;
  //                       },
  //                     ),
  //             );
  //           }),
  //           //=============================================================
  //           Align(
  //             alignment: Alignment.topCenter,
  //             child: Padding(
  //               padding: EdgeInsetsDirectional.fromSTEB(30.0, 15.0, 30.0, 5.0),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.max,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                     width: MediaQuery.sizeOf(context).width * 0.4,
  //                     height: 25.0,
  //                     decoration: BoxDecoration(
  //                       color: FlutterFlowTheme.of(context).accent3,
  //                       borderRadius: BorderRadius.circular(8.0),
  //                     ),
  //                     alignment: AlignmentDirectional(0.00, 0.00),
  //                     child: Row(
  //                       children: [
  //                         Expanded(
  //                           child: Padding(
  //                             padding: const EdgeInsets.only(top: 10.0),
  //                             child: TextFormField(
  //                               enabled: false,
  //                               // controller: _model
  //                               //     .textController18,
  //                               // focusNode: _model
  //                               //     .textFieldFocusNode18,
  //                               autofocus: false,
  //                               obscureText: false,
  //                               decoration: InputDecoration(
  //                                 isDense: true,
  //                                 labelStyle:
  //                                     FlutterFlowTheme.of(context).labelMedium,
  //                                 hintText: '        ค้นหาสถานที่',
  //                                 hintStyle: FlutterFlowTheme.of(context)
  //                                     .labelMedium
  //                                     .override(
  //                                       fontFamily: 'Kanit',
  //                                       color: FlutterFlowTheme.of(context)
  //                                           .primaryText,
  //                                     ),
  //                                 enabledBorder: InputBorder.none,
  //                                 focusedBorder: InputBorder.none,
  //                                 errorBorder: InputBorder.none,
  //                                 focusedErrorBorder: InputBorder.none,
  //                                 // suffixIcon: Icon(
  //                                 //   Icons.search_sharp,
  //                                 // ),
  //                               ),
  //                               style: FlutterFlowTheme.of(context).bodyMedium,
  //                               textAlign: TextAlign.center,
  //                               // validator: _model
  //                               //     .textController18Validator
  //                               //     .asValidator(
  //                               //         context),
  //                             ),
  //                           ),
  //                         ),
  //                         Icon(
  //                           Icons.search_sharp,
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // StreamBuilder<QuerySnapshot<Map<String, dynamic>>> priceTableApiEdit() {
  //   return StreamBuilder(
  //       stream: FirebaseFirestore.instance.collection('ตารางราคา').snapshots(),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return SizedBox();
  //         }
  //         if (snapshot.hasError) {
  //           return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
  //         }
  //         if (!snapshot.hasData) {
  //           return Text('ไม่พบข้อมูล');
  //         }
  //         if (snapshot.data!.docs.isEmpty) {
  //           print(snapshot.data);
  //         }

  //         Map<String, dynamic> priceTable = {};
  //         List<String> priceTableName = [];

  //         for (int index = 0; index < snapshot.data!.docs.length; index++) {
  //           final Map<String, dynamic> docData =
  //               snapshot.data!.docs[index].data() as Map<String, dynamic>;

  //           if (docData['PLIST_DESC2'] != '') {
  //             priceTable['key${index}'] = docData;
  //             priceTableName.add(docData['PLIST_DESC2']);
  //           }
  //         }
  //         return Align(
  //           alignment: AlignmentDirectional(0.00, 0.00),
  //           child: Padding(
  //             padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
  //             child: SizedBox(
  //               height: 55.0,
  //               child: FlutterFlowDropDown<String>(
  //                 controller: _model.dropDownValueController6 ??=
  //                     FormFieldController<String>(null),
  //                 options: priceTableName,
  //                 //  [
  //                 //   'ตารางราคา 1',
  //                 //   'ตารางราคา 2',
  //                 //   'ตารางราคา 3'
  //                 // ],
  //                 onChanged: (val) =>
  //                     setState(() => _model.dropDownValue6 = val),
  //                 height: 45.0,
  //                 textStyle: FlutterFlowTheme.of(context).bodyMedium,
  //                 hintText:
  //                     'ตารางราคา (MFOOD API) (เพื่อใช้ผูกกับที่อยู่ในการจัดส่ง)',
  //                 icon: Icon(
  //                   Icons.arrow_left_outlined,
  //                   color: FlutterFlowTheme.of(context).secondaryText,
  //                   size: 24.0,
  //                 ),
  //                 elevation: 2.0,
  //                 borderColor: FlutterFlowTheme.of(context).alternate,
  //                 borderWidth: 2.0,
  //                 borderRadius: 8.0,
  //                 margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
  //                 hidesUnderline: true,
  //                 isSearchable: false,
  //                 isMultiSelect: false,
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  StatefulBuilder addressShopEdit() {
    return StatefulBuilder(builder: (context, setState) {
      if (resultList.length == total3) {
      } else {
        for (int i = resultList.length; i < total3; i++) {
          print('add Address in addressShopEdit');
          print(resultList.length);
          print(total3);
          resultList.add({
            'ID': DateTime.now().toString(),
            'รหัสสาขา': '', //new
            'ชื่อสาขา': '', //new
            'HouseNumber': '',
            'VillageName': '',
            'Road': '', //new
            'Province': '',
            'District': '',
            'SubDistrict': '',
            'PostalCode': '',
            'Latitude': '',
            'Longitude': '',
            'Image': '',
            'ผู้ติดต่อ': '', //new
            'ตำแหน่ง': '', //new
            'หัวข้อโทรศัพท์': '',
            'โทรศัพท์': '', //new
            'ตารางราคา': '',
            'ที่อยู่จัดส่งและออกใบกำกับภาษี': '',
          });
          print(resultList.length);

          selected.add({
            'province_id': null,
            'amphure_id': null,
            'tambon_id': null,
          });

          postalCodeController!.add(TextEditingController());

          amphures!.add([]);
          tambons!.add([]);

          _mapController.add(Completer<GoogleMapController>());
          _kGooglePlexDialog.add(CameraPosition(
            target: google_maps.LatLng(13.7563309, 100.5017651),
            zoom: 14.4746,
          ));
          markersDialog.add(Set<Marker>());
          _mapKeyDialog.add(GlobalKey());

          searchMap.add(TextEditingController());

          phoneList!.add(PhoneNumber(isoCode: 'TH'));
          textFieldFocusSaka!.add(FocusNode());
          textFieldFocusRoad!.add(FocusNode());
          textFieldFocusNameSaka!.add(FocusNode());

          textFieldControllerPhoneAddress!.add(TextEditingController());

          textFieldFocusPhone!.add(FocusNode());
          textFieldFocusType!.add(FocusNode());
          textFieldFocusNameContract!.add(FocusNode());
          textFieldFocusHouseNumber!.add(FocusNode());
          textFieldFocusHouseMoo!.add(FocusNode());

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

          imageAddressNetwork!.add([]);
          imageAddressList!.add([]);
          imageAddressUint8List!.add([]);

          dropDownControllersPriceTable.add(FormFieldController(null));

          dropDownControllersBillTax.add(FormFieldController(null));

          latList!.add(TextEditingController());
          lotList!.add(TextEditingController());
          dropDownControllersimageAddress.add(FormFieldController<String>(''));

          addressProvincesStringControllerType!.add(TextEditingController());
          provincesString.add([]);

          print(resultList.length);
        }
      }
      print(resultList.length);
      print('1232312321');

      print(phoneList!.length);
      print(phoneList);
      print(textFieldControllerPhoneAddress);
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
        child: Column(
          children: [
            for (int index = 0; index < resultList.length; index++)
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        index == 0
                            ? ' ที่อยู่ตามบัตรประชาชน'
                            : ' ที่อยู่ในการจัดส่ง ลำดับที่ $index',
                        style: FlutterFlowTheme.of(context).bodySmall,
                      ),
                      total3 == 1
                          ? SizedBox()
                          : index + 1 == total3
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    right: 5.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      total3 = total3 - 1;

                                      resultList.removeLast();
                                      selected.removeLast();
                                      amphures!.removeLast();
                                      tambons!.removeLast();
                                      textFieldFocusHouseNumber!.removeLast();
                                      textFieldFocusHouseMoo!.removeLast();

                                      _mapController.removeLast();
                                      ;
                                      _kGooglePlexDialog.removeLast();
                                      ;
                                      markersDialog.removeLast();
                                      _mapKeyDialog.removeLast();

                                      searchMap.removeLast();

                                      phoneList!.removeLast();
                                      textFieldFocusSaka!.removeLast();
                                      textFieldFocusRoad!.removeLast();
                                      textFieldFocusNameSaka!.removeLast();

                                      textFieldControllerPhoneAddress!
                                          .removeLast();

                                      textFieldFocusPhone!.removeLast();
                                      textFieldFocusType!.removeLast();
                                      textFieldFocusNameContract!.removeLast();

                                      textFieldFocusVillageName!.removeLast();
                                      textFieldFocusPostalCode!.removeLast();
                                      textFieldFocusLatitude!.removeLast();
                                      textFieldFocusLongitude!.removeLast();
                                      // dropDownValueControllerProvince
                                      //     .removeLast();
                                      // dropDownValueControllerDistrict
                                      //     .removeLast();
                                      // dropDownValueControllerSubDistrict
                                      //     .removeLast();

                                      imageAddressNetwork!.removeLast();
                                      imageAddressList!.removeLast();
                                      imageAddressUint8List!.removeLast();

                                      dropDownControllersPriceTable
                                          .removeLast();

                                      dropDownControllersBillTax.removeLast();

                                      latList!.removeLast();
                                      lotList!.removeLast();

                                      addressProvincesStringControllerType!
                                          .removeLast();
                                      provincesString.removeLast();

                                      refreshAddressForDropdown(
                                          setState, index);

                                      toSetState();
                                    }),
                                    child: Icon(
                                      Icons.remove_circle_outline_outlined,
                                      size: 12,
                                      color: Colors.red.shade900,
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
                    // readOnly: true,

                    initialValue: resultList[index]['รหัสสาขา'],
                    onChanged: (value) {
                      resultList[index]['รหัสสาขา'] = value;

                      refreshAddressForDropdown(setState, index);

                      toSetState();
                    },
                    focusNode: textFieldFocusSaka![index],
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      isDense: true,
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      labelText: 'กรุณาพิมพ์รหัสสาขา',
                      hintText: 'กรุณาพิมพ์รหัสสาขา',
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
                    validator:
                        _model.textController15Validator.asValidator(context),
                  ),
                  index == 0
                      ? const SizedBox()
                      : const SizedBox(
                          height: 10,
                        ),
                  index == 0
                      ? SizedBox()
                      : TextFormField(
                          // controller: _model.textController15,
                          // readOnly: true,

                          initialValue: resultList[index]['ชื่อสาขา'],
                          onChanged: (value) {
                            resultList[index]['ชื่อสาขา'] = value;

                            refreshAddressForDropdown(setState, index);

                            toSetState();
                          },
                          focusNode: textFieldFocusNameSaka![index],
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            labelText: 'กรุณาพิมพ์ชื่อสาขา',
                            hintText: 'กรุณาพิมพ์ชื่อสาขา',
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
                          validator: _model.textController15Validator
                              .asValidator(context),
                        ),

                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    // controller: _model.textController15,
                    readOnly: checkIDforAddress
                        ? index == 0
                            ? true
                            : false
                        : false,
                    controller: checkIDforAddress
                        ? index == 0
                            ? houseNumber
                            : null
                        : null,

                    initialValue: !checkIDforAddress
                        ? resultList[index]['HouseNumber']
                        : null,
                    onChanged: (value) {
                      resultList[index]['HouseNumber'] = value;

                      refreshAddressForDropdown(setState, index);

                      toSetState();
                    },
                    focusNode: textFieldFocusHouseNumber![index],
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      filled: checkIDforAddress
                          ? index == 0
                              ? true
                              : false
                          : false, // ทำให้มีสีพื้นหลัง
                      fillColor: checkIDforAddress
                          ? index == 0
                              ? Colors.grey.shade300
                              : null
                          : null, // สีพื้นหลัง
                      isDense: true,
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      labelText: 'กรุณาพิมพ์ชื่อบ้านเลขที่',
                      hintText: 'กรุณาพิมพ์ชื่อบ้านเลขที่',
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
                    validator:
                        _model.textController15Validator.asValidator(context),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //======================= หมู่ ================================
                  TextFormField(
                    // controller: _model.textController15,
                    readOnly: checkIDforAddress
                        ? index == 0
                            ? true
                            : false
                        : false,
                    controller: checkIDforAddress
                        ? index == 0
                            ? moo
                            : null
                        : null,

                    initialValue:
                        !checkIDforAddress ? resultList[index]['Moo'] : null,
                    // initialValue: resultList[index]['Moo'],
                    onChanged: (value) {
                      resultList[index]['Moo'] = value;
                      print(index);
                      print(resultList[index]['Moo']);

                      refreshAddressForDropdown(setState, index);

                      toSetState();
                    },
                    focusNode: textFieldFocusHouseMoo![index],
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      filled: checkIDforAddress
                          ? index == 0
                              ? true
                              : false
                          : false, // ทำให้มีสีพื้นหลัง
                      fillColor: checkIDforAddress
                          ? index == 0
                              ? Colors.grey.shade300
                              : null
                          : null, // สีพื้นหลัง
                      isDense: true,
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      labelText: 'กรุณาพิมพ์หมู่',
                      hintText: 'กรุณาพิมพ์หมู่',
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
                    // validator:
                    //     _model.textController15Validator.asValidator(context),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                    child: TextFormField(
                      controller: checkIDforAddress
                          ? index == 0
                              ? nameMoo
                              : null
                          : null,
                      readOnly: checkIDforAddress
                          ? index == 0
                              ? true
                              : false
                          : false,

                      initialValue: !checkIDforAddress
                          ? resultList[index]['VillageName']
                          : null,
                      // initialValue: resultList[index]['VillageName'],
                      onChanged: (value) {
                        resultList[index]['VillageName'] = value;
                        refreshAddressForDropdown(setState, index);

                        toSetState();
                      },
                      focusNode: textFieldFocusVillageName![index],
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        filled: checkIDforAddress
                            ? index == 0
                                ? true
                                : false
                            : false, // ทำให้มีสีพื้นหลัง
                        fillColor: checkIDforAddress
                            ? index == 0
                                ? Colors.grey.shade300
                                : null
                            : null, // สีพื้นหลัง
                        isDense: true,
                        labelStyle: FlutterFlowTheme.of(context).labelMedium,
                        labelText: 'ชื่อหมู่บ้าน',
                        hintText: 'ชื่อหมู่บ้าน',
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
                      validator:
                          _model.textController16Validator.asValidator(context),
                    ),
                  ), //=============================================================
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    // controller: _model.textController15,
                    // readOnly: true,

                    controller: checkIDforAddress
                        ? index == 0
                            ? raod
                            : null
                        : null,
                    readOnly: checkIDforAddress
                        ? index == 0
                            ? true
                            : false
                        : false,

                    initialValue:
                        !checkIDforAddress ? resultList[index]['Road'] : null,
                    // initialValue: resultList[index]['Road'],
                    onChanged: (value) {
                      resultList[index]['Road'] = value;
                      refreshAddressForDropdown(setState, index);

                      toSetState();
                    },
                    // focusNode: textFieldFocusRoad![index],
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      filled: checkIDforAddress
                          ? index == 0
                              ? true
                              : false
                          : false, // ทำให้มีสีพื้นหลัง
                      fillColor: checkIDforAddress
                          ? index == 0
                              ? Colors.grey.shade300
                              : null
                          : null, // สีพื้นหลัง
                      isDense: true,
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      labelText: 'กรุณาพิมพ์ชื่อถนน',
                      hintText: 'กรุณาพิมพ์ชื่อถนน',
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
                    validator:
                        _model.textController15Validator.asValidator(context),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  checkIDforAddress
                      ? index == 0
                          ? TextFormField(
                              // controller: _model.textController15,
                              readOnly: checkIDforAddress
                                  ? index == 0
                                      ? true
                                      : false
                                  : false,
                              controller: checkIDforAddress
                                  ? index == 0
                                      ? province
                                      : null
                                  : null,
                              // initialValue: resultList[index]['Province'],

                              // controller: checkIDforAddress
                              //     ? index == 0
                              //         ? province
                              //         : null
                              //     : null,
                              onChanged: (value) {
                                // resultList[index]['Road'] = value;
                                // print(index);
                                // print(resultList[index]['Road']);

                                // refreshAddressForDropdown(setState, index);

                                // toSetState();
                              },
                              // focusNode: textFieldFocusRoad![index],
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                filled: checkIDforAddress
                                    ? index == 0
                                        ? true
                                        : false
                                    : false, // ทำให้มีสีพื้นหลัง
                                fillColor: checkIDforAddress
                                    ? index == 0
                                        ? Colors.grey.shade300
                                        : null
                                    : null, // สีพื้นหลัง
                                isDense: true,
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                labelText: 'จังหวัด',
                                hintText: 'จังหวัด',
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
                              validator: _model.textController15Validator
                                  .asValidator(context),
                            )
                          : dropdownList2(
                              label: 'Province: ',
                              id: 'province_id',
                              list: provinces,
                              child: 'amphure',
                              childsId: ['amphure_id', 'tambon_id'],
                              setChilds: [setAmphures, setTambons],
                              index: index,
                            )
                      : dropdownList2(
                          label: 'Province: ',
                          id: 'province_id',
                          list: provinces,
                          child: 'amphure',
                          childsId: ['amphure_id', 'tambon_id'],
                          setChilds: [setAmphures, setTambons],
                          index: index,
                        ),
                  SizedBox(height: 10.0),
                  checkIDforAddress
                      ? index == 0
                          ? TextFormField(
                              // controller: _model.textController15,
                              readOnly: checkIDforAddress
                                  ? index == 0
                                      ? true
                                      : false
                                  : false,
                              controller: checkIDforAddress
                                  ? index == 0
                                      ? district
                                      : null
                                  : null,
                              // initialValue: resultList[index]['District'],

                              // controller: checkIDforAddress
                              //     ? index == 0
                              //         ? district
                              //         : null
                              //     : null,
                              onChanged: (value) {
                                // resultList[index]['Road'] = value;
                                // print(index);
                                // print(resultList[index]['Road']);

                                // refreshAddressForDropdown(setState, index);

                                // toSetState();
                              },
                              // focusNode: textFieldFocusRoad![index],
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                filled: checkIDforAddress
                                    ? index == 0
                                        ? true
                                        : false
                                    : false, // ทำให้มีสีพื้นหลัง
                                fillColor: checkIDforAddress
                                    ? index == 0
                                        ? Colors.grey.shade300
                                        : null
                                    : null, // สีพื้นหลัง
                                isDense: true,
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                labelText: 'อำเภอ',
                                hintText: 'อำเภอ',
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
                              validator: _model.textController15Validator
                                  .asValidator(context),
                            )
                          : dropdownList(
                              label: 'District: ',
                              id: 'amphure_id',
                              list: amphures![index],
                              child: 'tambon',
                              childsId: ['tambon_id'],
                              setChilds: [setTambons],
                              index: index,
                            )
                      : dropdownList(
                          label: 'District: ',
                          id: 'amphure_id',
                          list: amphures![index],
                          child: 'tambon',
                          childsId: ['tambon_id'],
                          setChilds: [setTambons],
                          index: index,
                        ),
                  SizedBox(height: 10.0),
                  checkIDforAddress
                      ? index == 0
                          ? TextFormField(
                              // controller: _model.textController15,
                              readOnly: checkIDforAddress
                                  ? index == 0
                                      ? true
                                      : false
                                  : false,
                              // controller: checkIDforAddress
                              //     ? index == 0
                              //         ? subDistrict
                              //         : null
                              //     : null,
                              controller: checkIDforAddress
                                  ? index == 0
                                      ? subDistrict
                                      : null
                                  : null,
                              // initialValue: resultList[index]['SubDistrict'],
                              onChanged: (value) {
                                // resultList[index]['Road'] = value;
                                // print(index);
                                // print(resultList[index]['Road']);

                                // refreshAddressForDropdown(setState, index);

                                // toSetState();
                              },
                              // focusNode: textFieldFocusRoad![index],
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                filled: checkIDforAddress
                                    ? index == 0
                                        ? true
                                        : false
                                    : false, // ทำให้มีสีพื้นหลัง
                                fillColor: checkIDforAddress
                                    ? index == 0
                                        ? Colors.grey.shade300
                                        : null
                                    : null, // สีพื้นหลัง
                                isDense: true,
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                labelText: 'ตำบล',
                                hintText: 'ตำบล',
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
                              validator: _model.textController15Validator
                                  .asValidator(context),
                            )
                          : dropdownList(
                              label: 'Sub-district: ',
                              id: 'tambon_id',
                              list: tambons![index],
                              setChilds: null,
                              childsId: null,
                              index: index,
                            )
                      : dropdownList(
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

                  //======================= รหัสไปรษณีย์ ======================================
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                    child: TextFormField(
                      controller: postalCodeController![index],

                      // initialValue: resultList[index]
                      //     ['PostalCode'],
                      readOnly: checkIDforAddress
                          ? index == 0
                              ? true
                              : false
                          : false,
                      onChanged: (value) {
                        resultList[index]['PostalCode'] = value;

                        refreshAddressForDropdown(setState, index);

                        toSetState();
                      },
                      focusNode: textFieldFocusPostalCode![index],
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        filled: checkIDforAddress
                            ? index == 0
                                ? true
                                : false
                            : false, // ทำให้มีสีพื้นหลัง
                        fillColor: checkIDforAddress
                            ? index == 0
                                ? Colors.grey.shade300
                                : null
                            : null, // สีพื้นหลัง

                        isDense: true,
                        labelStyle: FlutterFlowTheme.of(context).labelMedium,
                        labelText: 'รหัสไปรษณีย์',
                        hintText: 'รหัสไปรษณีย์',
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
                      // validator: _model
                      //     .textController17Validator
                      //     .asValidator(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    // controller: _model.textController15,
                    // readOnly: true,

                    initialValue: resultList[index]['ผู้ติดต่อ'],
                    onChanged: (value) {
                      resultList[index]['ผู้ติดต่อ'] = value;

                      refreshAddressForDropdown(setState, index);

                      toSetState();
                    },
                    focusNode: textFieldFocusNameContract![index],
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      isDense: true,
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      labelText: 'กรุณาพิมพ์ชื่อผู้ติดต่อ',
                      hintText: 'กรุณาพิมพ์ชื่อผู้ติดต่อ',
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
                    validator:
                        _model.textController15Validator.asValidator(context),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    // controller: _model.textController15,
                    // readOnly: true,

                    initialValue: resultList[index]['ตำแหน่ง'],
                    onChanged: (value) {
                      resultList[index]['ตำแหน่ง'] = value;

                      refreshAddressForDropdown(setState, index);

                      toSetState();
                    },
                    focusNode: textFieldFocusType![index],
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      isDense: true,
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      labelText: 'กรุณาพิมพ์ชื่อตำแหน่ง',
                      hintText: 'กรุณาพิมพ์ชื่อตำแหน่ง',
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
                    validator:
                        _model.textController15Validator.asValidator(context),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber numberIn) {
                      print(numberIn.phoneNumber);
                      print(numberIn.isoCode);
                      print(numberIn.dialCode);

                      // List<String> parts =
                      //     numberIn.phoneNumber!.split(numberIn.dialCode!);

                      // String phoneNumberWithoutCountryCode =
                      //     numberIn.phoneNumber!.substring(parts.length);

                      resultList[index]['หัวข้อโทรศัพท์'] = numberIn.dialCode;
                      resultList[index]['โค้ดโทรศัพท์'] = numberIn.isoCode;
                      resultList[index]['โทรศัพท์'] = numberIn.phoneNumber;
                      print('-- 123 ---');

                      // phoneList![index] = numberIn;

                      print(index);
                      print(resultList[index]['โทรศัพท์']);

                      refreshAddressForDropdown(setState, index);

                      toSetState();
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      // useBottomSheetSafeArea: true,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: FlutterFlowTheme.of(context).bodyMedium,
                    // initialValue: phoneList![index],
                    initialValue: phoneList![index],

                    // textFieldController: _model.textController6,
                    textFieldController:
                        textFieldControllerPhoneAddress![index],

                    formatInput: true,
                    focusNode: textFieldFocusPhone![index],

                    // focusNode: _model.textFieldFocusNode6,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: OutlineInputBorder(),
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },

                    maxLength: 12,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    // ],
                    inputDecoration: InputDecoration(
                      isDense: true,
                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                      labelText: 'กรุณาพิมพ์โทรศัพท์',
                      hintText: 'กรุณาพิมพ์โทรศัพท์',
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
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          ' ตารางราคา (MFOOD API) (เพื่อใช้ผูกกับที่อยู่ในการจัดส่ง)',
                          style: FlutterFlowTheme.of(context).bodySmall,
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: AlignmentDirectional(0.00, 0.00),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      child: FlutterFlowDropDown<String>(
                        controller: dropDownControllersPriceTable[index],
                        options: priceTableName,
                        //  [
                        //   'ตารางราคา 1',
                        //   'ตารางราคา 2',
                        //   'ตารางราคา 3'
                        // ],
                        onChanged: (val) => setState(
                            () => resultList[index]['ตารางราคา'] = val),
                        height: 55.0,
                        textStyle: FlutterFlowTheme.of(context).bodyMedium,
                        hintText:
                            'ตารางราคา (MFOOD API) (เพื่อใช้ผูกกับที่อยู่ในการจัดส่ง)',
                        icon: Icon(
                          Icons.arrow_left_outlined,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                        elevation: 2.0,
                        borderColor: FlutterFlowTheme.of(context).alternate,
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

                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          ' กำหนดที่อยู่สำหรับออกใบกำกับภาษี',
                          style: FlutterFlowTheme.of(context).bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.00, 0.00),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      child: FlutterFlowDropDown<String>(
                        controller: dropDownControllersBillTax[index],
                        options: addressAllForDropdown,
                        //  [
                        //   'ตารางราคา 1',
                        //   'ตารางราคา 2',
                        //   'ตารางราคา 3'
                        // ],
                        onChanged: (val) => setState(() => resultList[index]
                            ['ที่อยู่จัดส่งและออกใบกำกับภาษี'] = val),
                        height: 55.0,
                        textStyle: FlutterFlowTheme.of(context).bodyMedium,
                        hintText: 'ที่อยู่สำหรับออกใบกำกับภาษี',
                        icon: Icon(
                          Icons.arrow_left_outlined,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                        elevation: 2.0,
                        borderColor: FlutterFlowTheme.of(context).alternate,
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

                  // TextFormField(
                  //   // controller: _model.textController15,
                  //   // readOnly: true,

                  //   initialValue: resultList[index]['โทรศัพท์'],
                  //   onChanged: (value) {
                  //     resultList[index]['โทรศัพท์'] = value;

                  //     refreshAddressForDropdown(setState, index);

                  //     toSetState();
                  //   },
                  //   focusNode: textFieldFocusPhone![index],
                  //   autofocus: false,
                  //   obscureText: false,
                  //   decoration: InputDecoration(
                  //     isDense: true,
                  //     labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  //     labelText: 'กรุณาพิมพ์โทรศัพท์',
                  //     hintText: 'กรุณาพิมพ์โทรศัพท์',
                  //     hintStyle: FlutterFlowTheme.of(context).labelMedium,
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: FlutterFlowTheme.of(context).alternate,
                  //         width: 2.0,
                  //       ),
                  //       borderRadius: BorderRadius.circular(8.0),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: FlutterFlowTheme.of(context).primary,
                  //         width: 2.0,
                  //       ),
                  //       borderRadius: BorderRadius.circular(8.0),
                  //     ),
                  //     errorBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: FlutterFlowTheme.of(context).error,
                  //         width: 2.0,
                  //       ),
                  //       borderRadius: BorderRadius.circular(8.0),
                  //     ),
                  //     focusedErrorBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: FlutterFlowTheme.of(context).error,
                  //         width: 2.0,
                  //       ),
                  //       borderRadius: BorderRadius.circular(8.0),
                  //     ),
                  //   ),
                  //   style: FlutterFlowTheme.of(context).bodyMedium,
                  //   textAlign: TextAlign.start,
                  //   validator:
                  //       _model.textController15Validator.asValidator(context),
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  mapList(index),

                  //======================= ละติจูด ลองติจูด ======================================
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   ' ละติดจูด ลองติจูด สามารถค้นหาได้จากการค้นหาในแผนที่',
                        //   style:
                        //       FlutterFlowTheme.of(context)
                        //           .bodySmall,
                        // ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: latList![index],
                                onChanged: (value) {
                                  resultList[index]['Latitude'] = value;

                                  refreshAddressForDropdown(setState, index);

                                  toSetState();
                                },
                                focusNode: textFieldFocusLatitude![index],
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  labelText: 'ละติจูด',
                                  hintText: 'ละติจูด',
                                  hintStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                // validator: _model
                                //     .textController171Validator
                                //     .asValidator(context),
                                keyboardType: TextInputType.number,
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
                                controller: lotList![index],
                                onChanged: (value) {
                                  resultList[index]['Longitude'] = value;

                                  refreshAddressForDropdown(setState, index);

                                  toSetState();
                                },
                                focusNode: textFieldFocusLongitude![index],
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  hintText: 'ลองติจูด',
                                  labelText: 'ลองติจูด',
                                  hintStyle:
                                      FlutterFlowTheme.of(context).labelMedium,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                // validator: _model
                                //     .textController172Validator
                                //     .asValidator(context),
                                keyboardType: TextInputType.number,
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
                  //======================= รูปภาพร้านค้า ======================================
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 5.0, 0.0, 5.0),
                          child: Text(
                            'รูปภาพร้านค้า อัพโหลดได้หลายภาพ (ต้องมีอย่างน้อย 1 รูป)',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 5.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent3,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 10.0, 10.0, 10.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  // width:
                                  // MediaQuery.of(context).size.width * 0.63 +
                                  //     (((MediaQuery.of(context).size.width *
                                  //                 0.63) /
                                  //             4.5) *
                                  //         (imageUrl.length - 2)),
                                  height: 100,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      ListView.builder(
                                        keyboardDismissBehavior:
                                            ScrollViewKeyboardDismissBehavior
                                                .onDrag,
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            imageAddressUint8List![index]!
                                                .length,
                                        itemBuilder: (context, indexj) {
                                          return Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 0, 10, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                      onTap: () =>
                                                          showCupertinoDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                true,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Container(
                                                                child: Stack(
                                                                  children: [
                                                                    imageAddressUint8List![index]![indexj] ==
                                                                                null ||
                                                                            imageAddressUint8List![index]![indexj]!.isEmpty
                                                                        ? PhotoView(
                                                                            // imageProvider: FileImage(images),
                                                                            imageProvider:
                                                                                NetworkImage(imageAddressNetwork![index]![indexj]!),
                                                                            // imageProvider: NetworkImage('URL ของรูปภาพ'),
                                                                          )
                                                                        : PhotoView(
                                                                            // imageProvider: FileImage(images),
                                                                            imageProvider:
                                                                                MemoryImage(imageAddressUint8List![index]![indexj]!),
                                                                            // imageProvider: NetworkImage('URL ของรูปภาพ'),
                                                                          ),
                                                                    Positioned(
                                                                      right: 10,
                                                                      top: 40,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              40,
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
                                                                                offset: Offset(0, 1), // changes position of shadow
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.cancel_outlined,
                                                                            color:
                                                                                Colors.black,
                                                                            size:
                                                                                40,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                      child: imageAddressUint8List![
                                                                          index]![
                                                                      indexj] ==
                                                                  null ||
                                                              imageAddressUint8List![
                                                                          index]![
                                                                      indexj]!
                                                                  .isEmpty
                                                          ? Image.network(
                                                              imageAddressNetwork![
                                                                      index]![
                                                                  indexj]!,
                                                              width: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.63) /
                                                                  4.5,
                                                              height: 100.0,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.memory(
                                                              imageAddressUint8List![
                                                                      index]![
                                                                  indexj]!,
                                                              width: (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.63) /
                                                                  4.5,
                                                              height: 100.0,
                                                              fit: BoxFit.cover,
                                                            )),
                                                  Positioned(
                                                    right: 0,
                                                    bottom: 0,
                                                    child: Container(
                                                      width: 20,
                                                      height: 15,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2),
                                                        child: Text(
                                                          '${indexj + 1}/${imageAddressList![index]!.length}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize: (lang ==
                                                              //         'my')
                                                              //     ? 10
                                                              //     : 10),
                                                              fontSize: 10),
                                                          textAlign:
                                                              TextAlign.center,
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                        onTap: () {
                                                          imageAddressUint8List![
                                                                  index]!
                                                              .removeAt(indexj);

                                                          imageAddressList![
                                                                  index]!
                                                              .removeAt(indexj);

                                                          imageAddressNetwork![
                                                                  index]!
                                                              .removeAt(indexj);

                                                          setState(() {});
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
                                      for (int i = 5;
                                          i >
                                              imageAddressUint8List![index]!
                                                  .length;
                                          i--)
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  5.0, 0.0, 5.0, 0.0),
                                          child: Container(
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.63) /
                                                4.5,
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                            ),
                                            child: Icon(
                                              FFIcons.kimagePlus,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 40.0,
                                            ),
                                          ),
                                        ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                // title: Text('Dialog Title'),
                                                // content: Text('This is the dialog content.'),
                                                actionsPadding:
                                                    EdgeInsets.all(20),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                actions: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 8.0,
                                                                  top: 5.0),
                                                          child: Text(
                                                            "กรุณาเลือกรูปแบบของรูปภาพค่ะ",
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineMedium,
                                                          ),
                                                        ),
                                                        const Divider(),
                                                        Container(
                                                          // color: Colors.white,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.60,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.06,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              Navigator.pop(
                                                                  context);
                                                              // //print('camera');
                                                              final picker =
                                                                  ImagePicker();
                                                              final pickedFile =
                                                                  await picker
                                                                      .pickImage(
                                                                maxWidth: 1000,
                                                                source: ImageSource
                                                                    .camera, // ใช้กล้องถ่ายรูป
                                                              );

                                                              File
                                                                  imageFileCrop =
                                                                  File(pickedFile!
                                                                      .path);
                                                              CroppedFile?
                                                                  croppedFile =
                                                                  await ImageCropper()
                                                                      .cropImage(
                                                                sourcePath:
                                                                    imageFileCrop
                                                                        .path,
                                                                aspectRatioPresets: [
                                                                  CropAspectRatioPreset
                                                                      .square,
                                                                  CropAspectRatioPreset
                                                                      .ratio3x2,
                                                                  CropAspectRatioPreset
                                                                      .original,
                                                                  CropAspectRatioPreset
                                                                      .ratio4x3,
                                                                  CropAspectRatioPreset
                                                                      .ratio16x9
                                                                ],
                                                                uiSettings: [
                                                                  AndroidUiSettings(
                                                                      toolbarTitle:
                                                                          'Cropper',
                                                                      toolbarColor:
                                                                          Colors
                                                                              .deepOrange,
                                                                      toolbarWidgetColor:
                                                                          Colors
                                                                              .white,
                                                                      initAspectRatio:
                                                                          CropAspectRatioPreset
                                                                              .original,
                                                                      lockAspectRatio:
                                                                          false),
                                                                  IOSUiSettings(
                                                                    title:
                                                                        'Cropper',
                                                                  ),
                                                                  WebUiSettings(
                                                                    context:
                                                                        context,
                                                                  ),
                                                                ],
                                                              );

                                                              //print(pickedFile!.path);
                                                              if (pickedFile!
                                                                  .path
                                                                  .isNotEmpty) {
                                                                //print('not empty');
                                                                if (croppedFile !=
                                                                    null) {
                                                                  Uint8List
                                                                      imageRead =
                                                                      await croppedFile
                                                                          .readAsBytes();

                                                                  imageAddressUint8List![
                                                                          index]!
                                                                      .add(
                                                                          imageRead);

                                                                  XFile?
                                                                      pickedFileForFirebase =
                                                                      XFile(croppedFile
                                                                          .path);
                                                                  imageAddressList![
                                                                          index]!
                                                                      .add(File(
                                                                          pickedFileForFirebase
                                                                              .path));

                                                                  imageAddressNetwork![
                                                                          index]!
                                                                      .add('');

                                                                  if (mounted) {
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                }

                                                                //print(imageUrl.length);
                                                                //print(imageLength);

                                                                // //print(imageRead);
                                                              }
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .camera_alt_outlined,
                                                                  color: Colors
                                                                      .black,
                                                                  size: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.025,
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.03,
                                                                ),
                                                                Text(
                                                                  'กล้องถ่ายรูป',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          // color: Colors.white,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.60,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.06,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              Navigator.pop(
                                                                  context);
                                                              //print('gallery');
                                                              final ImagePicker
                                                                  _picker =
                                                                  ImagePicker();
                                                              List<XFile>?
                                                                  images =
                                                                  await _picker
                                                                      .pickMultiImage(
                                                                          maxWidth:
                                                                              1000);

                                                              if (images
                                                                  .isNotEmpty) {
                                                                //print(images.length);
                                                                for (var element
                                                                    in images) {
                                                                  Uint8List
                                                                      imageRead =
                                                                      await element
                                                                          .readAsBytes();

                                                                  imageAddressUint8List![
                                                                          index]!
                                                                      .add(
                                                                          imageRead);

                                                                  imageAddressList![
                                                                          index]!
                                                                      .add(File(
                                                                          element
                                                                              .path));

                                                                  imageAddressNetwork![
                                                                          index]!
                                                                      .add('');

                                                                  setState(
                                                                      () {});
                                                                }
                                                              }
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .image_outlined,
                                                                  color: Colors
                                                                      .black,
                                                                  size: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.025,
                                                                ),
                                                                SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.03,
                                                                ),
                                                                Text(
                                                                  'แกลลอรี่',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .headlineMedium,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                                style:
                                                                    ButtonStyle(
                                                                  shape: MaterialStateProperty
                                                                      .all<
                                                                          RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0), // ปรับค่าตามต้องการ
                                                                    ),
                                                                  ),
                                                                  side:
                                                                      MaterialStatePropertyAll(
                                                                    BorderSide(
                                                                        color: Colors
                                                                            .red
                                                                            .shade300,
                                                                        width:
                                                                            1),
                                                                  ),
                                                                ),
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    CustomText(
                                                                  text:
                                                                      "   ยกเลิก   ",
                                                                  size: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.15,
                                                                  color: Colors
                                                                      .red
                                                                      .shade300,
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
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.63) /
                                              4.5,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            // color: FlutterFlowTheme
                                            //         .of(context)
                                            //     .primaryText,
                                            // color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                maxRadius: 30,
                                                backgroundColor: Colors.black,
                                                child: Icon(
                                                  FFIcons.kpaperclipPlus,
                                                  color: FlutterFlowTheme.of(
                                                          context)
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
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                ],
              ),
            //=========================== ปุ่ม เพิ่มที่อยู่ ==================================
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => total3 = total3 + 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'เพิ่มที่อยู่',
                              style: FlutterFlowTheme.of(context).bodyMedium,
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
    });
  }

  Widget mapList(int index) {
    double mapZoom = 14.4746;

    return StatefulBuilder(builder: (context, setState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                child: GoogleMap(
                  key: _mapKeyDialog[index],
                  // onTap: (argument) async {},
                  onTap: (argument) async {
                    // print('argument');
                    // print(argument);
                    // double lat = argument.latitude;
                    // double lot = argument.longitude;

                    // resultList[index]['Latitude'] =
                    //     lat == null ? "" : lat.toString();
                    // resultList[index]['Longitude'] =
                    //     lat == null ? "" : lot.toString();
                    // latList![index].text = lat == null ? "" : lat.toString();
                    // lotList![index].text = lat == null ? "" : lot.toString();

                    // _kGooglePlexDialog[index] = CameraPosition(
                    //   target: google_maps.LatLng(lat!, lot!),
                    //   zoom: mapZoom,
                    // );

                    // markersDialog[index].clear();

                    // markersDialog[index].add(
                    //   Marker(
                    //     markerId: MarkerId("your_marker_id"),
                    //     position: google_maps.LatLng(lat!, lot!),
                    //     infoWindow: InfoWindow(
                    //       title: searchMap[index].text,
                    //     ),
                    //   ),
                    // );

                    // _mapKeyDialog[index] = GlobalKey();
                    // final GoogleMapController controller =
                    //     await _mapController[index].future;

                    // controller.animateCamera(CameraUpdate.newCameraPosition(
                    //     _kGooglePlexDialog[index]));

                    // if (mounted) {
                    //   setState(() {});
                    // }

                    // เปิดหน้า B และรอรับ Map ที่ส่งกลับมา
                    Map<String, dynamic>? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => A07021MapWidget(
                            latitude: resultList[index]['Latitude'],
                            longtitude: resultList[index]['Longitude']),
                      ),
                    );
                    // อัปเดต State ด้วยค่าที่ส่งกลับมา
                    print(result!['latitudeToBack']);
                    print(result['longitudeToBack']);

                    resultList[index]['Latitude'] =
                        result['latitudeToBack'].toString();

                    resultList[index]['Longitude'] =
                        result['longitudeToBack'].toString();

                    print(resultList[index]['Latitude']);
                    print(resultList[index]['Longitude']);

                    latList![index] = TextEditingController(
                        text: result['latitudeToBack'].toString());
                    lotList![index] = TextEditingController(
                        text: result['longitudeToBack'].toString());

                    print(latList![index]);
                    print(lotList![index]);

                    double? lat = result['latitudeToBack'];
                    double? lot = result['longitudeToBack'];
                    _kGooglePlexDialog[index] = CameraPosition(
                      target: google_maps.LatLng(lat!, lot!),
                      zoom: mapZoom,
                    );

                    markersDialog[index].clear();

                    markersDialog[index].add(
                      Marker(
                        markerId: MarkerId("your_marker_id"),
                        position: google_maps.LatLng(lat, lot),
                        infoWindow: InfoWindow(
                          title: searchMap[index].text,
                        ),
                      ),
                    );

                    _mapKeyDialog[index] = GlobalKey();
                    // final GoogleMapController controller =
                    //     await _mapController[index].future;

                    // controller.animateCamera(CameraUpdate.newCameraPosition(
                    //     _kGooglePlexDialog[index]));

                    toSetState();

                    // setState(() {
                    //   print('SetState');
                    // });
                  },

                  mapType: ui_maps.MapType.hybrid,
                  initialCameraPosition: _kGooglePlexDialog[index],
                  markers: markersDialog[index], // เพิ่มนี่
                  onMapCreated: (GoogleMapController controller) {
                    _mapController[index].complete(controller);
                  },
                  onCameraMove: (CameraPosition position) {
                    mapZoom = position.zoom;
                  },
                ),
              ),
              //=============================================================
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: Padding(
              //     padding:
              //         EdgeInsetsDirectional.fromSTEB(30.0, 15.0, 30.0, 5.0),
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
              //                     controller: searchMap[index],
              //                     // focusNode: _model.textFieldFocusNode18,
              //                     autofocus: false,
              //                     obscureText: false,
              //                     decoration: InputDecoration(
              //                       isDense: true,
              //                       labelStyle: FlutterFlowTheme.of(context)
              //                           .labelMedium,
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
              //                     ),
              //                     style:
              //                         FlutterFlowTheme.of(context).bodyMedium,
              //                     textAlign: TextAlign.center,
              //                     // validator: _model.textController18Validator
              //                     //     .asValidator(context),
              //                   ),
              //                 ),
              //               ),
              //               GestureDetector(
              //                 onTap: () async {
              //                   print(searchMap[index].text);
              //                   print('search button');
              //                   try {
              //                     List<Location> locations =
              //                         await locationFromAddress(
              //                             searchMap[index].text);
              //                     print(searchMap[index].text);

              //                     print(locations);

              //                     if (locations.isNotEmpty) {
              //                       Location location = locations.first;
              //                       print(
              //                           'Latitude: ${location.latitude}, Longitude: ${location.longitude}');
              //                       double lat = location.latitude;
              //                       double lot = location.longitude;
              //                       resultList[index]['Latitude'] =
              //                           lat == null ? "" : lat.toString();
              //                       resultList[index]['Longitude'] =
              //                           lat == null ? "" : lot.toString();
              //                       latList![index].text =
              //                           lat == null ? "" : lat.toString();
              //                       lotList![index].text =
              //                           lat == null ? "" : lot.toString();

              //                       _kGooglePlexDialog[index] = CameraPosition(
              //                         target: google_maps.LatLng(lat!, lot!),
              //                         zoom: 14.4746,
              //                       );
              //                       markersDialog[index].clear();
              //                       markersDialog[index].add(
              //                         Marker(
              //                           markerId: MarkerId("your_marker_id"),
              //                           position: google_maps.LatLng(
              //                               lat!, lot!), // ตำแหน่ง
              //                           infoWindow: InfoWindow(
              //                             title:
              //                                 'searchMap[index].text', // ชื่อของปักหมุด
              //                             // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
              //                             onTap: () async {
              //                               // _mapKey = GlobalKey();
              //                               if (mounted) {}
              //                             },
              //                           ),
              //                         ),
              //                       );
              //                       _mapKeyDialog[index] = GlobalKey();

              //                       if (mounted) {}
              //                     } else {
              //                       print(
              //                           'No location found for the given address');
              //                     }
              //                   } catch (e) {
              //                     print('Error: $e');
              //                     await Fluttertoast.showToast(
              //                         msg:
              //                             "   ไม่มีสถานที่นี้ค่ะ กรุณากรอกชื่อสถานที่ใหม่ค่ะ   ",
              //                         toastLength: Toast.LENGTH_SHORT,
              //                         gravity: ToastGravity.CENTER,
              //                         timeInSecForIosWeb: 5,
              //                         backgroundColor: Colors.red,
              //                         textColor: Colors.white,
              //                         fontSize: 16.0);
              //                   }
              //                   print('search button');

              //                   // refreshAddressForDropdown(setState, index);

              //                   setState(() {});
              //                 },
              //                 child: Icon(
              //                   Icons.search_sharp,
              //                 ),
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
          SizedBox(
            height: 10,
          ),
        ],
      );
    });
  }

  StatefulBuilder groupProdutcoBuyEdit() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            for (int index = 0; index < total2; index++)
              Align(
                alignment: AlignmentDirectional(0.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '  กลุ่มสินค้าที่สั่งชื้อ ลำดับที่ ${index + 1}',
                            style: FlutterFlowTheme.of(context).bodySmall,
                          ),
                          total2 == 1
                              ? SizedBox()
                              : index + 1 == total2
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        right: 5.0,
                                      ),
                                      child: GestureDetector(
                                        onTap: () => setState(() {
                                          total2 = total2 - 1;
                                          dropDownControllers2.removeLast();
                                          dropDownValues2.removeLast();
                                        }),
                                        child: Icon(
                                          Icons.remove_circle_outline_outlined,
                                          size: 12,
                                          color: Colors.red.shade900,
                                        ),
                                      ),
                                    )
                                  : SizedBox()
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      FlutterFlowDropDown<String>(
                        // controller: _model.dropDownValueController1 ??=
                        //     FormFieldController<String>(null),
                        controller: dropDownControllers2[index],
                        options: categoryNameList

                        // [
                        //   'ประเภทสินค้า 1',
                        //   'ประเภทสินค้า 2',
                        //   'ประเภทสินค้า 3',
                        //   'ประเภทสินค้า 4',
                        //   'ประเภทสินค้า 5'
                        // ]
                        ,
                        searchHintText: 'กลุ่มสินค้าที่สั่งชื้อ',
                        // onChanged: (val) =>
                        //     setState(() => _model.dropDownValue1 = val),
                        onChanged: (val) => setState(() {
                          dropDownValues2[index] = val;
                        }),
                        height: 55.0,
                        textStyle: FlutterFlowTheme.of(context).bodyMedium,
                        hintText: 'กลุ่มสินค้าที่สั่งชื้อ',
                        icon: Icon(
                          Icons.arrow_left_outlined,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 24.0,
                        ),
                        elevation: 2.0,
                        borderColor: FlutterFlowTheme.of(context).alternate,
                        borderWidth: 2.0,
                        borderRadius: 8.0,
                        margin: EdgeInsetsDirectional.fromSTEB(
                            16.0, 4.0, 16.0, 4.0),
                        hidesUnderline: true,
                        isSearchable: false,
                        isMultiSelect: false,
                      ),
                    ],
                  ),
                ),
              ),
            //===========================กลุ่มสินค้าที่สั่งชื้อ ปุ่ม==================================
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      total2 = total2 + 1;
                      dropDownControllers2.add(FormFieldController(''));
                      dropDownValues2.add('');
                    }),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'เลือกกลุ่มสินค้าเพิ่ม',
                              style: FlutterFlowTheme.of(context).bodyMedium,
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
    );
  }

  Padding dateToWorkEdit(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'ระยะเวลาเปิดดำเนินการ',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
              child: TextFormField(
                controller: _model.textController12,
                focusNode: _model.textFieldFocusNode12,
                autofocus: false,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  labelText: 'จำนวนปี',
                  hintText: 'จำนวนปี',
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
                textAlign: TextAlign.left,
                // validator: _model
                //     .textController12Validator
                //     .asValidator(context),
                keyboardType: TextInputType.number,

                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(2),
                ],
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(
                //       RegExp(r'[0-9]')),
                // ],
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
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
              child: TextFormField(
                controller: _model.textController121,
                focusNode: _model.textFieldFocusNode121,
                autofocus: false,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  labelText: 'จำนวนเดือน',
                  hintText: 'จำนวนเดือน',
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
                textAlign: TextAlign.left,
                // validator: _model
                //     .textController12Validator
                //     .asValidator(context),
                keyboardType: TextInputType.number,

                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(
                //       RegExp(r'[0-9]')),
                // ],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^([1-9]|1[0-2])$')),
                  LengthLimitingTextInputFormatter(2),
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
          ),
        ],
      ),
    );
  }

  StatefulBuilder groupProductEdit() {
    return StatefulBuilder(
      builder: (context, setState) {
        if (productType!.length == total) {
        } else {
          for (int i = productType!.length; i < total; i++) {
            productType!.add(TextEditingController());
            textFieldFocusProductType!.add(FocusNode());
          }
        }
        return Column(
          children: [
            for (int index = 0; index < total; index++)
              Align(
                alignment: AlignmentDirectional(0.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                  child: Column(
                    children: [
                      // TypeAheadField(
                      //   suggestionsCallback: (search) {
                      //     return ['อาหาร', 'ทะเล', 'เครื่องดื่ม', 'นำ'];
                      //   },
                      //   builder: (context, controller, focusNode) {
                      //     return TextFormField(
                      //       controller: productType![index],
                      //       // initialValue: productType![index].text,
                      //       // controller: controller,
                      //       focusNode: focusNode,

                      //       onChanged: (value) {
                      //         productType![index].text = value;
                      //         print(productType![index]);
                      //         setState(() {});
                      //       },
                      //       // controller: productType![index],
                      //       // focusNode: textFieldFocusProductType![index],
                      //       autofocus: false,
                      //       obscureText: false,
                      //       decoration: InputDecoration(
                      //         labelText: 'ประเภทสินค้า',
                      //         isDense: true,
                      //         labelStyle:
                      //             FlutterFlowTheme.of(context).labelMedium,
                      //         hintText: 'ประเภทสินค้า',
                      //         hintStyle:
                      //             FlutterFlowTheme.of(context).labelMedium,
                      //         enabledBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //             color: FlutterFlowTheme.of(context).alternate,
                      //             width: 2.0,
                      //           ),
                      //           borderRadius: BorderRadius.circular(8.0),
                      //         ),
                      //         focusedBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //             color: FlutterFlowTheme.of(context).primary,
                      //             width: 2.0,
                      //           ),
                      //           borderRadius: BorderRadius.circular(8.0),
                      //         ),
                      //         errorBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //             color: FlutterFlowTheme.of(context).error,
                      //             width: 2.0,
                      //           ),
                      //           borderRadius: BorderRadius.circular(8.0),
                      //         ),
                      //         focusedErrorBorder: OutlineInputBorder(
                      //           borderSide: BorderSide(
                      //             color: FlutterFlowTheme.of(context).error,
                      //             width: 2.0,
                      //           ),
                      //           borderRadius: BorderRadius.circular(8.0),
                      //         ),
                      //       ),
                      //       style: FlutterFlowTheme.of(context).bodyMedium,
                      //       // textAlign: TextAlign.start,

                      //       textAlign: TextAlign.start,

                      //       // validator: _model.textController11Validator
                      //       //     .asValidator(context),
                      //       keyboardType: TextInputType.text,
                      //       // inputFormatters: [
                      //       //   FilteringTextInputFormatter
                      //       //       .allow(RegExp(r'[0-9]')),
                      //       // ],

                      //       validator: (value) {
                      //         // if (value!.isNotEmpty) {
                      //         //   if (value.length > 2) {
                      //         //     return 'เลข 1 - 2 หลักค่ะ';
                      //         //   }
                      //         // }

                      //         return null;
                      //       },
                      //     );
                      //   },
                      //   itemBuilder: (context, customerData) {
                      //     return ListTile(
                      //       title: Text(customerData),
                      //       subtitle: Text(customerData),
                      //     );
                      //   },
                      //   onSelected: (value) {
                      //     productType![index] =
                      //         TextEditingController(text: value);
                      //     print(productType![index]);
                      //     setState(() {});
                      //   },
                      // ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '  ประเภทสินค้าที่ขายในปัจจุบัน ลำดับที่ ${index + 1}',
                            style: FlutterFlowTheme.of(context).bodySmall,
                          ),
                          total == 1
                              ? SizedBox()
                              : index + 1 == total
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        right: 5.0,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() => total = total - 1);
                                          productType!.removeLast();
                                          textFieldFocusProductType!
                                              .removeLast();
                                        },
                                        child: Icon(
                                          Icons.remove_circle_outline_outlined,
                                          size: 12,
                                          color: Colors.red.shade900,
                                        ),
                                      ),
                                    )
                                  : SizedBox()
                        ],
                      ),
                      SizedBox(
                        height: 2,
                      ),

                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                        child: TypeAheadField(
                          suggestionsCallback: (search) {
                            return productTypeEmployee;
                          },
                          builder: (context, controller, focusNode) {
                            return TextFormField(
                              controller: productType![index],
                              // initialValue: productType![index].text,
                              // controller: controller,
                              focusNode: focusNode,

                              onChanged: (value) {
                                productType![index].text = value;
                                print(productType![index]);
                                setState(() {});
                                // scrollUp();
                              },
                              // controller: productType![index],
                              // focusNode: textFieldFocusProductType![index],
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'ประเภทสินค้า',
                                isDense: true,
                                labelStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                hintText: 'ประเภทสินค้า',
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
                              // textAlign: TextAlign.start,

                              textAlign: TextAlign.start,

                              // validator: _model.textController11Validator
                              //     .asValidator(context),
                              keyboardType: TextInputType.text,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter
                              //       .allow(RegExp(r'[0-9]')),
                              // ],

                              validator: (value) {
                                // if (value!.isNotEmpty) {
                                //   if (value.length > 2) {
                                //     return 'เลข 1 - 2 หลักค่ะ';
                                //   }
                                // }

                                return null;
                              },
                            );
                          },
                          itemBuilder: (context, customerData) {
                            return ListTile(
                              title: Text(customerData),
                              subtitle: Text(customerData),
                            );
                          },
                          onSelected: (value) {
                            productType![index] =
                                TextEditingController(text: value);
                            print(productType![index]);
                            // scrollUp();
                            setState(() {});
                          },
                        ),
                        // child: TextFormField(
                        //   controller: productType![index],
                        //   focusNode: textFieldFocusProductType![index],
                        //   autofocus: false,
                        //   obscureText: false,
                        //   decoration: InputDecoration(
                        //     labelText: 'ประเภทสินค้า',
                        //     isDense: true,
                        //     labelStyle:
                        //         FlutterFlowTheme.of(context).labelMedium,
                        //     hintText: 'ประเภทสินค้า',
                        //     hintStyle: FlutterFlowTheme.of(context).labelMedium,
                        //     enabledBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(
                        //         color: FlutterFlowTheme.of(context).alternate,
                        //         width: 2.0,
                        //       ),
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(
                        //         color: FlutterFlowTheme.of(context).primary,
                        //         width: 2.0,
                        //       ),
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //     errorBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(
                        //         color: FlutterFlowTheme.of(context).error,
                        //         width: 2.0,
                        //       ),
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //     focusedErrorBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(
                        //         color: FlutterFlowTheme.of(context).error,
                        //         width: 2.0,
                        //       ),
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //   ),
                        //   style: FlutterFlowTheme.of(context).bodyMedium,
                        //   textAlign: TextAlign.start,
                        //   // validator: _model.textController11Validator
                        //   //     .asValidator(context),
                        //   keyboardType: TextInputType.text,
                        //   // inputFormatters: [
                        //   //   FilteringTextInputFormatter
                        //   //       .allow(RegExp(r'[0-9]')),
                        //   // ],
                        //   validator: (value) {
                        //     // if (value!.isNotEmpty) {
                        //     //   if (value.length > 2) {
                        //     //     return 'เลข 1 - 2 หลักค่ะ';
                        //     //   }
                        //     // }

                        //     return null;
                        //   },
                        // ),
                      ),
                      // SizedBox(
                      //   height: 55,
                      //   child:
                      //       FlutterFlowDropDown<String>(
                      //     // controller: _model.dropDownValueController1 ??=
                      //     //     FormFieldController<String>(null),
                      //     controller:
                      //         dropDownControllers[index],
                      //     options: categoryNameList

                      //     // [
                      //     //   'ประเภทสินค้า 1',
                      //     //   'ประเภทสินค้า 2',
                      //     //   'ประเภทสินค้า 3',
                      //     //   'ประเภทสินค้า 4',
                      //     //   'ประเภทสินค้า 5'
                      //     // ]
                      //     ,
                      //     searchHintText:
                      //         'ประเภทสินค้าที่ขายในปัจจุบัน',
                      //     // onChanged: (val) =>
                      //     //     setState(() => _model.dropDownValue1 = val),
                      //     onChanged: (val) =>
                      //         setState(() {
                      //       dropDownValues[index] = val;
                      //     }),
                      //     height: 45.0,
                      //     textStyle:
                      //         FlutterFlowTheme.of(context)
                      //             .bodyMedium,
                      //     hintText:
                      //         'ประเภทสินค้าที่ขายในปัจจุบัน',
                      //     icon: Icon(
                      //       Icons.arrow_left_outlined,
                      //       color: FlutterFlowTheme.of(
                      //               context)
                      //           .secondaryText,
                      //       size: 24.0,
                      //     ),
                      //     elevation: 2.0,
                      //     borderColor:
                      //         FlutterFlowTheme.of(context)
                      //             .alternate,
                      //     borderWidth: 2.0,
                      //     borderRadius: 8.0,
                      //     margin: EdgeInsetsDirectional
                      //         .fromSTEB(
                      //             16.0, 4.0, 16.0, 4.0),
                      //     hidesUnderline: true,
                      //     isSearchable: false,
                      //     isMultiSelect: false,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            //=============================================================
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => total = total + 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'เลือกกลุ่มสินค้าเพิ่ม',
                              style: FlutterFlowTheme.of(context).bodyMedium,
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
    );
  }

  Padding goalToSellEdit(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: TextFormField(
        controller: _model.textController11,
        focusNode: _model.textFieldFocusNode11,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'เป้าการขาย',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'เป้าการขาย',
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
        // validator: _model.textController11Validator
        //     .asValidator(context),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
    );
  }

  Padding shopNameEdit(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: TextFormField(
        controller: _model.textController10,
        focusNode: _model.textFieldFocusNode10,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          labelText:
              widget.type == 'Company' ? 'ชื่อร้าน' : 'ชื่อร้าน/แผงในตลาด',
          hintText:
              widget.type == 'Company' ? 'ชื่อร้าน' : 'ชื่อร้าน/แผงในตลาด',
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
        validator: _model.textController10Validator.asValidator(context),
      ),
    );
  }

  Padding dateToSendEdit() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkTimeToSend
                ? Text('!! กรุณากรอกวันที่มากกว่าวันที่ปัจจุบันค่ะ',
                    style: FlutterFlowTheme.of(context).redSmall)
                : SizedBox(),
            GestureDetector(
              onTap: () async {
                print('Gesture');
                bottomPickerToSend(context);
                // await selectDateToSend(context);
                setState(
                  () {
                    print(_model.textController7.text);
                    print(_model.textController8.text);
                    print(_model.textController9.text);
                  },
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'วัน / เดือน / ปี ที่เริ่มจัดส่ง ',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  SizedBox(
                      width: 40,
                      child: Icon(
                        Icons.calendar_month,
                        color: FlutterFlowTheme.of(context).alternate,
                      )),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: TextFormField(
                        onChanged: (value) {
                          int day = int.parse(_model.textController7.text);
                          int month = int.parse(_model.textController8.text);
                          int year =
                              int.parse(_model.textController9.text) - 543;
                          var check = DateTime(year, month, day, 0, 0, 0)
                              .isBefore(DateTime.now());

                          if (check == true) {
                            setState(
                              () {
                                checkTimeToSend = true;
                              },
                            );
                          } else {
                            setState(
                              () {
                                checkTimeToSend = false;
                              },
                            );
                          }
                        },
                        onTap: () {
                          // bottomPickerToSend(context);
                        },
                        // readOnly: true,
                        controller: _model.textController7,
                        focusNode: _model.textFieldFocusNode7,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          labelText: 'วันที่',
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
                        // validator: _model.textController7Validator
                        //     .asValidator(context),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^([1-9]|1[0-9]|2[0-9]|3[0-1])$')),
                          LengthLimitingTextInputFormatter(2),
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
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: TextFormField(
                        onChanged: (value) {
                          int day = int.parse(_model.textController7.text);
                          int month = int.parse(_model.textController8.text);
                          int year =
                              int.parse(_model.textController9.text) - 543;
                          var check = DateTime(year, month, day, 0, 0, 0)
                              .isBefore(DateTime.now());

                          if (check == true) {
                            setState(
                              () {
                                checkTimeToSend = true;
                              },
                            );
                          } else {
                            setState(
                              () {
                                checkTimeToSend = false;
                              },
                            );
                          }
                        },
                        onTap: () {
                          // bottomPickerToSend(context);
                        },
                        // readOnly: true,
                        controller: _model.textController8,
                        focusNode: _model.textFieldFocusNode8,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          labelText: 'เดือน',
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
                        keyboardType: TextInputType.number,

                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^([1-9]|1[0-2])$')),
                          LengthLimitingTextInputFormatter(2),
                        ],
                        // validator:
                        //     _model.textController8Validator.asValidator(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: TextFormField(
                        onChanged: (value) {
                          int day = int.parse(_model.textController7.text);
                          int month = int.parse(_model.textController8.text);
                          int year =
                              int.parse(_model.textController9.text) - 543;
                          var check = DateTime(year, month, day, 0, 0, 0)
                              .isBefore(DateTime.now());

                          if (check == true) {
                            setState(
                              () {
                                checkTimeToSend = true;
                              },
                            );
                          } else {
                            setState(
                              () {
                                checkTimeToSend = false;
                              },
                            );
                          }
                        },
                        onTap: () {
                          // bottomPickerToSend(context);
                        },
                        // readOnly: true,

                        controller: _model.textController9,
                        focusNode: _model.textFieldFocusNode9,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          labelText: 'พ.ศ.',
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
                        // validator: _model.textController9Validator
                        //     .asValidator(context),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(4),
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
          ],
        );
      }),
    );
  }

  Padding phoneEdit(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: Column(
        children: [
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber numberIn) {
              print(numberIn.phoneNumber);
              print(numberIn.isoCode);
              print(numberIn.dialCode);
              number = numberIn;
            },
            onInputValidated: (bool value) {
              print(value);
            },
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              // useBottomSheetSafeArea: true,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle: FlutterFlowTheme.of(context).bodyMedium,
            initialValue: number,
            textFieldController: _model.textController6,
            formatInput: true,
            focusNode: _model.textFieldFocusNode6,
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            inputBorder: OutlineInputBorder(),
            onSaved: (PhoneNumber number) {
              print('On Saved: $number');
            },

            maxLength: 12,
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            // ],
            inputDecoration: InputDecoration(
              isDense: true,
              labelStyle: FlutterFlowTheme.of(context).labelMedium,
              labelText: 'เบอร์โทรศัพท์',
              hintText: 'เบอร์โทรศัพท์',
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
            textAlign: TextAlign.start,
          ),
          // TextFormField(
          //   controller: _model.textController6,
          //   focusNode: _model.textFieldFocusNode6,
          //   autofocus: false,
          //   obscureText: false,
          //   decoration: InputDecoration(
          //     isDense: true,
          //     labelStyle: FlutterFlowTheme.of(context).labelMedium,
          //     labelText: 'เบอร์โทรศัพท์',
          //     hintText: 'เบอร์โทรศัพท์',
          //     hintStyle: FlutterFlowTheme.of(context).labelMedium,
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: FlutterFlowTheme.of(context).alternate,
          //         width: 2.0,
          //       ),
          //       borderRadius: BorderRadius.circular(8.0),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: FlutterFlowTheme.of(context).primary,
          //         width: 2.0,
          //       ),
          //       borderRadius: BorderRadius.circular(8.0),
          //     ),
          //     errorBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: FlutterFlowTheme.of(context).error,
          //         width: 2.0,
          //       ),
          //       borderRadius: BorderRadius.circular(8.0),
          //     ),
          //     focusedErrorBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: FlutterFlowTheme.of(context).error,
          //         width: 2.0,
          //       ),
          //       borderRadius: BorderRadius.circular(8.0),
          //     ),
          //   ),
          //   style: FlutterFlowTheme.of(context).bodyMedium,
          //   textAlign: TextAlign.start,
          //   // validator: _model.textController6Validator
          //   //     .asValidator(context),
          //   keyboardType: TextInputType.number,
          //   inputFormatters: [
          //     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          //   ],
          //   validator: (value) {
          //     // if (value!.isNotEmpty) {
          //     //   if (value.length != 10) {
          //     //     return 'กรุณาใส่เบอร์โทรศัพท์ 10 หลักเท่านั้นค่ะ';
          //     //   }
          //     // }

          //     return null;
          //   },
          // ),
        ],
      ),
    );
  }

  StatefulBuilder idCustomerEdit() {
    //เลขบัตรประชาชน
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _model.textController5.text.length < 13
                ? Text('!! กรุณากรอกเลข 13 หลักค่ะ',
                    style: FlutterFlowTheme.of(context)
                        .redSmall //redSmall orangeSmall

                    )
                : checkID == 'red'
                    ? Text('!! หมายเลขนี้มีสมาชิกในระบบแล้ว',
                        style: FlutterFlowTheme.of(context)
                            .redSmall //redSmall orangeSmall

                        )
                    : checkID == 'orange'
                        ? Text('ลูกค้าที่เคย Reject',
                            style: FlutterFlowTheme.of(context)
                                .orangeSmall //redSmall orangeSmall

                            )
                        : Text('สามารถเปิดบัญชีได้',
                            style: FlutterFlowTheme.of(context)
                                .greenSmall //redSmall orangeSmall

                            ),
            SizedBox(
              height: 5,
            ),
            TextFormField(
              onChanged: (value) async {
                print(value.length);
                if (value.length == 13) {
                  FirebaseFirestore firestore = FirebaseFirestore.instance;

                  QuerySnapshot querySnapshot = await firestore
                      .collection(AppSettings.customerType == CustomerType.Test
                          ? 'CustomerTest'
                          : 'Customer')
                      .where('เลขบัตรประชาชน',
                          isEqualTo: _model.textController5.text)
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    querySnapshot.docs.forEach((doc) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      print('Field Value: $data');

                      var fieldValue = data['สถานะ'];
                      var fieldValue2 = data['รอการอนุมัติ'];
                      var fieldValue3 = data['บันทึกพร้อมตรวจ'];

                      if (!fieldValue && !fieldValue2 && !fieldValue3) {
                        checkID = 'orange';
                        setState(() {});
                      } else {
                        checkID = 'red';
                        setState(() {});
                      }
                    });
                  } else {
                    print('ไม่พบเอกสารที่ตรงกับเงื่อนไข');
                    checkID = 'green';
                    setState(() {});
                  }
                } else {
                  checkID = 'green';
                  setState(() {});
                }
              },
              controller: _model.textController5,
              focusNode: _model.textFieldFocusNode5,
              autofocus: false,
              obscureText: false,

              decoration: InputDecoration(
                isDense: true,
                labelStyle: FlutterFlowTheme.of(context).labelMedium,
                labelText: 'เลขที่บัตรประชาชน',
                hintText: 'เลขที่บัตรประชาชน',
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
              // validator: _model.textController5Validator
              //     .asValidator(context),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(13),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
          ],
        ),
      );
    });
  }

  Padding companyFundEdit(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: TextFormField(
        controller: _model.textController5Company,
        focusNode: _model.textFieldFocusNode5Company,
        autofocus: false,
        obscureText: false,

        decoration: InputDecoration(
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'ทุนจดทะเบียน',
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
        // validator: _model.textController5Validator
        //     .asValidator(context),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
    );
  }

  Padding idCompanyEdit(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _model.textController41Company.text.length < 13
              ? Text('กรุณากรอกเลข 13 หลักค่ะ',
                  style: FlutterFlowTheme.of(context)
                      .redSmall //redSmall orangeSmall

                  )
              : checkID == 'red'
                  ? Text('!! หมายเลขนี้มีสมาชิกในระบบแล้ว',
                      style: FlutterFlowTheme.of(context)
                          .redSmall //redSmall orangeSmall

                      )
                  : checkID == 'orange'
                      ? Text('ลูกค้าที่เคย Reject',
                          style: FlutterFlowTheme.of(context)
                              .orangeSmall //redSmall orangeSmall

                          )
                      : Text('สามารถเปิดบัญชีได้',
                          style: FlutterFlowTheme.of(context)
                              .greenSmall //redSmall orangeSmall

                          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            onChanged: (value) async {
              print(value.length);
              if (value.length == 13) {
                FirebaseFirestore firestore = FirebaseFirestore.instance;

                QuerySnapshot querySnapshot = await firestore
                    .collection(AppSettings.customerType == CustomerType.Test
                        ? 'CustomerTest'
                        : 'Customer')
                    .where('เลขประจำตัวผู้เสียภาษี',
                        isEqualTo: _model.textController41Company.text)
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  querySnapshot.docs.forEach((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    print('Field Value: $data');

                    var fieldValue = data['สถานะ'];
                    var fieldValue2 = data['รอการอนุมัติ'];
                    var fieldValue3 = data['บันทึกพร้อมตรวจ'];

                    if (!fieldValue && !fieldValue2 && !fieldValue3) {
                      checkID = 'orange';
                      setState(() {});
                    } else {
                      checkID = 'red';
                      setState(() {});
                    }
                  });
                } else {
                  print('ไม่พบเอกสารที่ตรงกับเงื่อนไข');
                  checkID = 'green';
                  setState(() {});
                }
              } else {
                checkID = 'green';
                setState(() {});
              }
            },
            controller: _model.textController41Company,
            focusNode: _model.textFieldFocusNode41Company,
            autofocus: false,
            obscureText: false,

            decoration: InputDecoration(
              isDense: true,
              labelStyle: FlutterFlowTheme.of(context).labelMedium,
              labelText: 'เลขประจำตัวผู้เสียภาษี',
              hintText: 'เลขประจำตัวผู้เสียภาษี',
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
            // validator: _model.textController5Validator
            //     .asValidator(context),
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(13),
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
        ],
      ),
    );
  }

  Padding birthdayCustomerEdit() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
      child: StatefulBuilder(builder: (context, setState) {
        return GestureDetector(
          onTap: () async {
            print('Gesture');
            bottomPicker(context);
            // await selectDate(context);
            setState(
              () {
                print(_model.textController2.text);
                print(_model.textController3.text);
                print(_model.textController4.text);
              },
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'วันเดือนปีเกิด',
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
              SizedBox(
                  width: 40,
                  child: Icon(
                    Icons.calendar_month,
                    color: FlutterFlowTheme.of(context).alternate,
                  )),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                  child: GestureDetector(
                    onTap: () async {
                      print('Gesture');
                      // bottomPicker(context);
                      // await selectDate(context);
                    },
                    child: TextFormField(
                      onTap: () {
                        // bottomPicker(context);
                      },
                      // readOnly: true,
                      controller: _model.textController2,
                      focusNode: _model.textFieldFocusNode2,
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: FlutterFlowTheme.of(context).labelMedium,
                        labelText: 'วันที่',
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
                      // validator: _model.textController2Validator
                      //     .asValidator(context),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^([1-9]|1[0-9]|2[0-9]|3[0-1])$')),
                        LengthLimitingTextInputFormatter(2),
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
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      print('Gesture');
                      // await selectDate(context);
                    },
                    child: Container(
                      child: TextFormField(
                        onTap: () {
                          // bottomPicker(context);
                        },
                        // readOnly: true,
                        controller: _model.textController3,
                        focusNode: _model.textFieldFocusNode3,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          labelText: 'เดือน',
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
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^([1-9]|1[0-2])$')),
                          LengthLimitingTextInputFormatter(2),
                        ],
                        validator: _model.textController3Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      print('Gesture');
                      // await selectDate(context);
                    },
                    child: Container(
                      child: TextFormField(
                        onTap: () {
                          // bottomPicker(context);
                        },
                        // readOnly: true,
                        controller: _model.textController4,
                        focusNode: _model.textFieldFocusNode4,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          labelText: 'พ.ศ.',
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
                        // validator: _model.textController4Validator
                        //     .asValidator(context),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(4),
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
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Padding birthdayCompanyEdit() {
    // bool isDateValid(int year, int month, int day) {
    //   if (month < 1 || month > 12) {
    //     return false; // เดือนต้องอยู่ระหว่าง 1-12
    //   }

    //   int daysInMonth =
    //       DateTime(year, month + 1, 0).day; // หาจำนวนวันในเดือนนั้น ๆ

    //   if (day < 1 || day > daysInMonth) {
    //     return false; // วันต้องอยู่ระหว่าง 1-จำนวนวันในเดือนนั้น
    //   }

    //   return true;
    // }

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
      child: StatefulBuilder(builder: (context, setState) {
        return GestureDetector(
          onTap: () async {
            print('Gesture');
            // await selectDateCompany(context);
            bottomPickerCompany(context);

            setState(
              () {
                print(_model.textController2Company.text);
                print(_model.textController3Company.text);
                print(_model.textController4Company.text);
              },
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'วันเดือนปีที่จดจัดตั้ง',
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
              SizedBox(
                  width: 40,
                  child: Icon(
                    Icons.calendar_month,
                    color: FlutterFlowTheme.of(context).alternate,
                  )),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      print('Gesture');
                      // await selectDateCompany(
                      // context);
                    },
                    child: Container(
                      child: TextFormField(
                        onTap: () {
                          // bottomPickerCompany(context);
                        },
                        // readOnly: true,
                        controller: _model.textController2Company,
                        focusNode: _model.textFieldFocusNode2Company,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          labelText: 'วันที่',
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
                        // validator: _model.textController2Validator
                        //     .asValidator(context),
                        keyboardType: TextInputType.number,

//                         inputFormatters: [
//   FilteringTextInputFormatter.allow(RegExp(r'^[1-9]|[1-2][0-9]|3[0-1]$')),
//   LengthLimitingTextInputFormatter(2),
// ],

                        inputFormatters: [
                          // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^([1-9]|1[0-9]|2[0-9]|3[0-1])$')),

                          LengthLimitingTextInputFormatter(2),
                        ],
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            if (int.parse(value) > 31 || int.parse(value) < 0) {
                              return 'เลข 1 - 31 ค่ะ';
                            }
                          }

                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      print('Gesture');
                      // await selectDateCompany(
                      // context);
                    },
                    child: Container(
                      child: TextFormField(
                        onTap: () {
                          // bottomPickerCompany(context);
                        },
                        // readOnly: true,
                        controller: _model.textController3Company,
                        focusNode: _model.textFieldFocusNode3Company,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          labelText: 'เดือน',
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
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^([1-9]|1[0-2])$')),
                          LengthLimitingTextInputFormatter(2),
                        ],
                        validator: _model.textController3Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    print('Gesture');
                    // await selectDateCompany(
                    //     context);
                  },
                  child: Container(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: TextFormField(
                        onTap: () {
                          // bottomPickerCompany(context);
                        },
                        // readOnly: true,
                        controller: _model.textController4Company,
                        focusNode: _model.textFieldFocusNode4Company,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          labelText: 'พ.ศ.',
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
                        // validator: _model.textController4Validator
                        //     .asValidator(context),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(4),
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
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Padding vatCompanyEdit(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'VAT',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
          FlutterFlowRadioButton(
            options: ['มี', 'ไม่มี'].toList(),
            onChanged: (val) => setState(() {}),
            controller: _model.radioButtonValueControllerVat ??=
                FormFieldController<String>(null),
            optionHeight: 32.0,
            textStyle: FlutterFlowTheme.of(context).labelMedium,
            selectedTextStyle: FlutterFlowTheme.of(context).bodyMedium,
            buttonPosition: RadioButtonPosition.left,
            direction: Axis.horizontal,
            radioButtonColor: FlutterFlowTheme.of(context).primary,
            inactiveRadioButtonColor:
                FlutterFlowTheme.of(context).secondaryText,
            toggleable: false,
            horizontalAlignment: WrapAlignment.start,
            verticalAlignment: WrapCrossAlignment.start,
          ),
        ],
      ),
    );
  }

  Padding nameCustomerEdit(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        controller: _model.textController1,
        focusNode: _model.textFieldFocusNode1,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'ชื่อ นามสกุล',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'ชื่อ นามสกุล',
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
        validator: _model.textController1Validator.asValidator(context),
      ),
    );
  }

  Padding nameCompany(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        controller: _model.textController1Company,
        focusNode: _model.textFieldFocusNode1Company,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'ชื่อบริษัn',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'ชื่อบริษัn',
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
        validator: _model.textController1Validator.asValidator(context),
      ),
    );
  }

  Padding typeNameEdit(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'คำนำหน้า',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
          FlutterFlowRadioButton(
            options: ['นาย', 'นาง', 'นางสาว'].toList(),
            onChanged: (val) => setState(() {}),
            controller: _model.radioButtonValueController ??=
                FormFieldController<String>(null),
            optionHeight: 32.0,
            textStyle: FlutterFlowTheme.of(context).labelMedium,
            selectedTextStyle: FlutterFlowTheme.of(context).bodyMedium,
            buttonPosition: RadioButtonPosition.left,
            direction: Axis.horizontal,
            radioButtonColor: FlutterFlowTheme.of(context).primary,
            inactiveRadioButtonColor:
                FlutterFlowTheme.of(context).secondaryText,
            toggleable: false,
            horizontalAlignment: WrapAlignment.start,
            verticalAlignment: WrapCrossAlignment.start,
          ),
        ],
      ),
    );
  }

  //================================================================================================

  Padding houseNumberFirst(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            checkIDforAddress = false;
          });
        },
        controller: homeAddress,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'บ้านเลขที่',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'บ้านเลขที่',
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
        // validator: _model.textController1Validator.asValidator(context),
      ),
    );
  }

  Padding mooFirst(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            checkIDforAddress = false;
          });
        },
        controller: mooAddress,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'หมู่',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'หมู่',
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
        // validator: _model.textController1Validator.asValidator(context),
      ),
    );
  }

  Padding nameMooFirst(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            checkIDforAddress = false;
          });
        },
        controller: nameMooAddress,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'ชื่อหมู่บ้าน',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'ชื่อหมู่บ้าน',
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
        // validator: _model.textController1Validator.asValidator(context),
      ),
    );
  }

  Padding roadFirst(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            checkIDforAddress = false;
          });
        },
        controller: roadAddress,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'ถนน',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'ถนน',
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
        // validator: _model.textController1Validator.asValidator(context),
      ),
    );
  }

  Padding proviceFirst(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        controller: proviceAddress,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'จังหวัด',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'จังหวัด',
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
        // validator: _model.textController1Validator.asValidator(context),
      ),
    );
  }

  // Padding districFirst(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
  //     child: TextFormField(
  //       controller: districAddress,
  //       autofocus: false,
  //       obscureText: false,
  //       decoration: InputDecoration(
  //         labelText: 'อำเภอ',
  //         isDense: true,
  //         labelStyle: FlutterFlowTheme.of(context).labelMedium,
  //         hintText: 'อำเภอ',
  //         hintStyle: FlutterFlowTheme.of(context).labelMedium,
  //         enabledBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: FlutterFlowTheme.of(context).alternate,
  //             width: 2.0,
  //           ),
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: FlutterFlowTheme.of(context).primary,
  //             width: 2.0,
  //           ),
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         errorBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: FlutterFlowTheme.of(context).error,
  //             width: 2.0,
  //           ),
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         focusedErrorBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: FlutterFlowTheme.of(context).error,
  //             width: 2.0,
  //           ),
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //       ),
  //       style: FlutterFlowTheme.of(context).bodyMedium,
  //       textAlign: TextAlign.start,
  //       // validator: _model.textController1Validator.asValidator(context),
  //     ),
  //   );
  // }

  // Padding subDistricFirst(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
  //     child: TextFormField(
  //       controller: subDistricAddress,
  //       autofocus: false,
  //       obscureText: false,
  //       decoration: InputDecoration(
  //         labelText: 'ตำบล',
  //         isDense: true,
  //         labelStyle: FlutterFlowTheme.of(context).labelMedium,
  //         hintText: 'ตำบล',
  //         hintStyle: FlutterFlowTheme.of(context).labelMedium,
  //         enabledBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: FlutterFlowTheme.of(context).alternate,
  //             width: 2.0,
  //           ),
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: FlutterFlowTheme.of(context).primary,
  //             width: 2.0,
  //           ),
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         errorBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: FlutterFlowTheme.of(context).error,
  //             width: 2.0,
  //           ),
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         focusedErrorBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: FlutterFlowTheme.of(context).error,
  //             width: 2.0,
  //           ),
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //       ),
  //       style: FlutterFlowTheme.of(context).bodyMedium,
  //       textAlign: TextAlign.start,
  //       // validator: _model.textController1Validator.asValidator(context),
  //     ),
  //   );
  // }

  Padding codeFirst(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        controller: codeAddress,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'รหัสไปรษณีย์',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'รหัสไปรษณีย์',
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
        // validator: _model.textController1Validator.asValidator(context),
      ),
    );
  }
  //================================================================================================

  void _pickImageCameraIdCard() async {
    // //print('camera');
    final picker2 = ImagePicker();
    final pickedFile2 = await picker2.pickImage(
      maxWidth: 1000,
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
      File _file = File(pickedFile2.path);
      OCRReadIdCard(_file);
    }
  }

  void _pickImageGalleryIdCard() async {
    //print('gallery');
    final ImagePicker _picker2 = ImagePicker();
    XFile? images2 = await _picker2.pickImage(source: ImageSource.gallery);
    if (images2 != null) {
      File _file = File(images2.path);
      OCRReadIdCard(_file);
    }
  }

  OCRReadIdCard(_imgFile) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      showDialog(
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
                          "ต้องเชื่อมต่ออินเทอร์เน็ต",
                          style: FlutterFlowTheme.of(context).headlineMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
                        child: Text(
                          "เพื่อใช้งานฟังก์ชั่นอ่านบัตรประชาชน",
                          style: FlutterFlowTheme.of(context).headlineMedium,
                        ),
                      ),
                      const Divider(),
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

      // QuickAlert.show(
      //   context: context,
      //   type: QuickAlertType.error,
      //   title: 'ต้องเชื่อมต่ออินเทอร์เน็ต',
      //   text: 'เพื่อใช้งานฟังก์ชั่นอ่านบัตรประชาชน',
      // );
    } else {
      try {
        WidgetService().checkSpeedInternetSnackbar(context);
        // ProgressDialog pd = ProgressDialog(context: context);

        print('_imgFile =>${_imgFile}');

        File file = _imgFile;
        String fileName =
            '${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}';

        Reference ref = FirebaseStorage.instance.ref('IDCard/${fileName}.png');
        UploadTask task = ref.putFile(file);
        WidgetService().checkSpeedInternetSnackbar(context);
        CustomProgressDialog.show(context);

        // pd.show(
        //     max: 100,
        //     msg: 'กำลังอัพโหลดภาพบัตรประชาชน 10%',
        //     msgFontSize: 18.0,
        //     barrierColor: Color.fromRGBO(9, 9, 9, 0.5),
        //     progressType: ProgressType.valuable,
        //     hideValue: true,
        //     barrierDismissible: true);
        task.snapshotEvents.listen((TaskSnapshot snapshot) {
          print('Task state: ${snapshot.state}');
          print(
              'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
          // pd.update(
          //     value:
          //         (((snapshot.bytesTransferred / snapshot.totalBytes) * 100) - 10)
          //             .toInt());
        }, onError: (e) {
          print('onError upload: ${task.snapshot}');
          if (e.code == 'permission-denied') {
            print('User does not have permission to upload to this reference.');
          }

          showDialog(
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
                              "อ่านข้อมูลบัตรประชาชนไม่สำเร็จ\nให้ทำการเลือกรูปบัตรประชาชนใหม่",
                              style:
                                  FlutterFlowTheme.of(context).headlineMedium,
                            ),
                          ),
                          const Divider(),
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
                                    size: MediaQuery.of(context).size.height *
                                        0.15,
                                    color: Colors.red.shade300,
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
          // QuickAlert.show(
          //   context: context,
          //   type: QuickAlertType.error,
          //   title:
          //       'อ่านข้อมูลบัตรประชาชนไม่สำเร็จ\nให้ทำการเลือกรูปบัตรประชาชนใหม่',
          //   text: '',
          // );
        });

        try {
          await task;
          WidgetService().checkSpeedInternetSnackbar(context);
          String? urlForSave = await ref.getDownloadURL();
          print('urlForSave =>${urlForSave}');
          WidgetService().checkSpeedInternetSnackbar(context);
          await Future.delayed(Duration(seconds: 2), () async {
            print("รอให้รูปภาพบันทึกให้เรียบร้อยใน storage ก่อน 2 seconds");
            // pd.update(value: 20, msg: "กำลังอ่านข้อมูลบัตรประชาชน 20%");
          });
          await Future.delayed(Duration(seconds: 2), () async {
            print("รอให้รูปภาพบันทึกให้เรียบร้อยใน storage รออีก 2 seconds");
            // pd.update(value: 42, msg: "กำลังอ่านข้อมูลบัตรประชาชน 42%");
          });
          await Future.delayed(Duration(seconds: 2), () async {
            print("รออีก 2 seconds");
            // pd.update(value: 60, msg: "กำลังอ่านข้อมูลบัตรประชาชน 60%");
            print('==========================');
            try {
              var token = await FirebaseAppCheck.instance.getToken(true);
              print("token => ${token}");
            } catch (e) {
              print(e);
            }
            print('==========================');

            HttpsCallable callable =
                FirebaseFunctions.instance.httpsCallable('readOCR');
            final resultCloudFunction = await callable
                .call(<String, dynamic>{"imgName": "${fileName}.png"});
            // pd.update(value: 70, msg: "กำลังอ่านข้อมูลบัตรประชาชน 70%");
            List result = [];
            List arMonth = [
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

            print(
                "before: resultCloudFunction.data['textOCR'] => ${resultCloudFunction.data['textOCR']}");
            var tmp = resultCloudFunction.data['textOCR'].replaceAll('\n', ' ');
            var tmpArr = tmp.split(' ');
            var f = new FormatMethod();

            tmpArr.asMap().forEach((i, val) {
              result.add(val);
            });
            print(result);

            result.removeWhere((element) => element == '');
            print(result);
            try {
              // เปิดแล้ว เปลี่ยนข้อมูลด้านล่างนี้เอาได้เลยนะครับ

              result.asMap().forEach((k, v) {
                print(k);
                print(v);
                if ((v.endsWith('ber') ||
                        v.endsWith('er') ||
                        v.startsWith('เล') ||
                        v.endsWith('าชน')) &&
                    f.isNumeric(result[k + 1])) {
                  textMap['idcard'] = result[k + 1] +
                      result[k + 2] +
                      result[k + 3] +
                      result[k + 4] +
                      result[k + 5];
                } else if (v.startsWith('ชื่อ') ||
                    v.startsWith('ชือ') ||
                    v.endsWith('สกุล') ||
                    v.endsWith('กุล') ||
                    v.endsWith('กล')) {
                  if (result[k + 1] == 'นาย' || result[k + 1] == 'พระ') {
                    textMap['sex'] = 1;
                    textMap['sexName'] = "ชาย";
                  } else {
                    textMap['sex'] = 2;
                    textMap['sexName'] = "หญิง";
                  }
                  textMap['name'] = result[k + 2];
                  textMap['surname'] = result[k + 3];
                } else if (v.startsWith('เกิด') ||
                    v.startsWith('เก') ||
                    v.endsWith('นที่') ||
                    v.endsWith('วนี') ||
                    v.endsWith('นท่')) {
                  textMap['day'] = int.parse(result[k + 1]);
                  arMonth.asMap().forEach((key, value) {
                    if (value == result[k + 2]) {
                      textMap['month'] = key;
                    }
                  });
                  textMap['year'] = int.parse(result[k + 3]) - 543;
                  textMap['birthday'] = textMap['year'].toString() +
                      '-' +
                      textMap['month'].toString().padLeft(2, '0') +
                      '-' +
                      textMap['day'].toString().padLeft(2, '0');
                } else if (v.startsWith('ที่อ') ||
                    v.startsWith('ทีอ') ||
                    v.endsWith('อยู่')) {
                  textMap['address'] =
                      '${result[k + 1]} ${result[k + 2]} ${result[k + 3]}';
                } else if (v.startsWith('ต.') || v.startsWith('แขวง')) {
                  textMap['subdist'] = v.startsWith('ต.') ? v.split('.')[1] : v;
                  print("textMap['subdist'] => ${textMap['subdist']}");
                } else if (v.startsWith('อ.') || v.startsWith('เขต')) {
                  textMap['dist'] = v.startsWith('อ.') ? v.split('.')[1] : v;
                  print("textMap['dist'] => ${textMap['dist']}");
                } else if (v.startsWith('จ.')) {
                  textMap['province'] = v.split('.')[1];
                  print("textMap['province'] => ${textMap['province']}");
                }
              });
              if (textMap['province'] == null) {
                textMap['province'] = 'กรุงเทพมหานคร';
              }

              print('-------------------');
              print(textMap);
              print(result[0]);
              print('-------------------');

              _model.textController1.text =
                  '${textMap['name']} ${textMap['surname']}';

              print(result[13]);
              print(result[14]);

              _model.textControllerName =
                  TextEditingController(text: result[15]);

              _model.textControllerSurname =
                  TextEditingController(text: result[16]);

              // print(_model.textControllerName.text);
              // print(_model.textControllerSurname.text);

              _model.textController5.text =
                  result[5] + result[6] + result[7] + result[8] + result[9];

              // _model.textControllerName =
              //     TextEditingController(text: result[13]);

              // _model.textControllerSurname =
              //     TextEditingController(text: result[14]);

              // _model.textController5.text =
              //     result[3] + result[4] + result[5] + result[6] + result[7];

              FirebaseFirestore firestore = FirebaseFirestore.instance;

              QuerySnapshot querySnapshot = await firestore
                  .collection(AppSettings.customerType == CustomerType.Test
                      ? 'CustomerTest'
                      : 'Customer')
                  .where('เลขบัตรประชาชน',
                      isEqualTo: _model.textController5.text)
                  .get();

              if (querySnapshot.docs.isNotEmpty) {
                querySnapshot.docs.forEach((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  print('Field Value: $data');

                  var fieldValue = data['สถานะ'];
                  var fieldValue2 = data['รอการอนุมัติ'];
                  var fieldValue3 = data['บันทึกพร้อมตรวจ'];

                  if (!fieldValue && !fieldValue2 && !fieldValue3) {
                    checkID = 'orange';
                    setState(() {});
                  } else {
                    checkID = 'red';
                    setState(() {});
                  }
                });
              } else {
                print('ไม่พบเอกสารที่ตรงกับเงื่อนไข');
                checkID = 'green';
                setState(() {});
              }

              // _model.radioButtonValueController!.value = result[12];

              // _model.textController2.text = result[32];
              // _model.textController3.text = textMap['month'].toString();
              // _model.textController4.text = result[34];

              _model.radioButtonValueController!.value = result[14];

              _model.textController2.text = result[24];
              _model.textController3.text = textMap['month'].toString();
              _model.textController4.text = result[26];
              //   Map findProince = jsonProvince.firstWhere((ele) => ele['PROVINCE_NAME'].toString().contains(textMap['province'].toString().trim()),
              //       orElse: () => {"PROVINCE_ID": -1});
              //
              //   textMap['province_id'] = (findProince['PROVINCE_ID'] != -1) ? findProince['PROVINCE_ID'] : null;
              //
              //   _name.text = '${textMap['name']}';
              //   _surname.text = '${textMap['surname']}';
              //   _idcard.text = '${textMap['idcard']}';
              //   _sex = '${textMap['sex']}';
              //   _province = '${textMap['province_id']}';
              //   selectDate = DateTime(textMap['year'], textMap['month'], textMap['day']);
              //   _birthday.text = f.ThaiDateFormat(textMap['birthday']);
              //   _address.text = '${textMap['address']}';
              //   if (textMap['province_id'] != null) {
              //     var findAmphur = jsonAmphur.firstWhere(
              //         (ele) => (ele['AMPHUR_NAME'].toString().contains(textMap['dist']) && ele['PROVINCE_ID'] == textMap['province_id']),
              //         orElse: () => null);
              //     textMap['dist_id'] = findAmphur != null ? findAmphur['AMPHUR_ID'] : null;
              //     if (textMap['dist_id'] != null) {
              //       await getDistrict(textMap['province_id']).whenComplete(() => _district = textMap['dist_id'].toString());
              //       var findSubdist = jsonDistrict.firstWhere(
              //           (ele) => (ele['DISTRICT_NAME'].toString().contains(textMap['subdist']) && ele['AMPHUR_ID'] == textMap['dist_id']),
              //           orElse: () => null);
              //       textMap['subdist_id'] = findSubdist != null ? findSubdist['DISTRICT_ID'] : null;
              //       if (textMap['subdist_id'] != null) {
              //         await getSubDistrict(textMap['dist_id']).whenComplete(() {
              //           _subDistrict = textMap['subdist_id'].toString();
              //           var tmp = tmpSubDistrict.firstWhere((element) => element['DISTRICT_ID'].toString() == _subDistrict);
              //           _zipcode.text = tmp['ZIP_CODE'].toString();
              //         });
              //       }
              //     }
              //   }
              CustomProgressDialog.hide(context);
              // pd.close();
              // setState(() {});
            } catch (e) {
              //   //show error dialog
              CustomProgressDialog.hide(context);
              // pd.close();
              //   setState(() {
              //     // _sex = null;
              //     // _province = null;
              //     // _district = null;
              //     // _subDistrict = null;
              //     // _zipcode.clear();
              //   });
              //   print('create textMap ERROR :: ${e.toString()}');
              print('create textMap ERROR :: ${e}');
            }
          });
        } catch (e) {
          // pd.close();
          CustomProgressDialog.hide(context);
          print('upload ERROR :: ${e}');

          showDialog(
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
                              "อ่านข้อมูลบัตรประชาชนไม่สำเร็จ\nให้ทำการเลือกรูปบัตรประชาชนใหม่",
                              style:
                                  FlutterFlowTheme.of(context).headlineMedium,
                            ),
                          ),
                          const Divider(),
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
                                    size: MediaQuery.of(context).size.height *
                                        0.15,
                                    color: Colors.red.shade300,
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

          // QuickAlert.show(
          //   context: context,
          //   type: QuickAlertType.error,
          //   title:
          //       'อ่านข้อมูลบัตรประชาชนไม่สำเร็จ\nให้ทำการเลือกรูปบัตรประชาชนใหม่',
          //   text: '',
          // );
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<dynamic> imageDialogIdCard() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
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
                        "กรุณาเลือกรูปแบบของบัตรประชาชน",
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
                          _pickImageCameraIdCard();
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
                          _pickImageGalleryIdCard();
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

  InkWell ocrEdit(BuildContext context) {
    return InkWell(
      onTap: () async {
        await imageDialogIdCard();
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
              child: Icon(
                FFIcons.kocr,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 24.0,
              ),
            ),
            Text(
              'กรุณาเชื่อมต่ออินเตอร์เน็ต สามารถเปิดกล้องถ่ายหน้าบัตรและอ่าน OCR ได้จากที่นี่',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ],
        ),
      ),
    );
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
                  mainAxisAlignment: MainAxisAlignment.end,
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
                        final imageSign = await sign!.getData();

                        var data = await imageSign.toByteData(
                            format: ui.ImageByteFormat.png);
                        final encoded =
                            base64.encode(data!.buffer.asUint8List());

                        base64ImgSign = encoded;

                        Uint8List uint8list = base64.decode(encoded);

                        imageSignToShow = Image.memory(uint8list);

                        signConfirm = true;
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

  showPreviewImage2(int index, String typeImage, int indexList) {
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
                      imageProvider: NetworkImage(
                          imageUrlFromFirestoreList2![indexList]![index]),
                    )
                  : PhotoView(
                      // imageProvider: FileImage(images),
                      imageProvider:
                          MemoryImage(imageUint8ListList2![indexList]![index]!),
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

//   Future<dynamic> mapDialog(
//     List<Map<String, dynamic>> address,
//     String? idMarker,
//   ) async {
//     String? idMarkerIn = idMarker;
//     late MarkerId markerId;
//     List<bool> boolCheck = [];

//     double? lat;
//     double? lot;
//     List<Map<String, dynamic>> addressThai = [];

//     if (idMarkerIn == null) {
//       markersDialog.clear();
//       _kGooglePlexDialog = CameraPosition(
//         target: google_maps.LatLng(13.7563309, 100.5017651),
//         zoom: 14.4746,
//       );
//     } else {
//       for (int i = 0; i < address.length; i++) {
//         if (address[i]['ID'] == idMarkerIn) {
//           _kGooglePlexDialog = CameraPosition(
//             target: google_maps.LatLng(double.parse(address[i]['Latitude']!),
//                 double.parse(address[i]['Longitude']!)),
//             zoom: 14.4746,
//           );
//           markersDialog.add(
//             Marker(
//               markerId: MarkerId("your_marker_id"),
//               position: google_maps.LatLng(
//                   double.parse(address[i]['Latitude']!),
//                   double.parse(address[i]['Longitude']!)), // ตำแหน่ง
//               // infoWindow: InfoWindow(
//               //   title: _model.textController18.text, // ชื่อของปักหมุด
//               //   // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
//               // ),
//             ),
//           );
//         }
//       }
//     }

//     for (int i = 0; i < address.length; i++) {
//       //====================================================================
//       if (address[i]['ID'] == idMarkerIn) {
//         boolCheck.add(true);
//         // _kGooglePlexDialog = CameraPosition(
//         //   target: google_maps.LatLng(double.parse(address[i]['Latitude']!),
//         //       double.parse(address[i]['Longitude']!)),
//         //   zoom: 15,
//         // );

//         // markersDialog.add(
//         //   Marker(
//         //     markerId: MarkerId("your_marker_id"),
//         //     position: google_maps.LatLng(double.parse(address[i]['Latitude']!),
//         //         double.parse(address[i]['Longitude']!)), // ตำแหน่ง
//         //     // infoWindow: InfoWindow(
//         //     //   title: _model.textController18.text, // ชื่อของปักหมุด
//         //     //   // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
//         //     // ),
//         //   ),
//         // );

//         _mapKeyDialog = GlobalKey();
//       } else {
//         boolCheck.add(false);
//       }
//       print(boolCheck);
//       print(idMarkerIn);
// //====================================================================

//       List<Map<String, dynamic>> mapProvincesList =
//           provinces!.cast<Map<String, dynamic>>();

//       List<Map<String, dynamic>> mapList =
//           amphures![i].cast<Map<String, dynamic>>();
//       List<Map<String, dynamic>> tambonList =
//           tambons![i].cast<Map<String, dynamic>>();
//       String? provincesName;
//       String? amphorName;
//       String? tambonName;
//       print('Check map errorr $i');
// //====================================================================
//       if (address[i]['Province'] == '' || address[i]['Province'] == null) {
//         provincesName = '';
//       } else {
//         Map<String, dynamic> resultProvince = mapProvincesList.firstWhere(
//             (element) => element['name_th'] == address[i]['Province'],
//             orElse: () => {});

//         provincesName = resultProvince['name_th'] ?? '';
//       }
// //====================================================================
//       if (address[i]['District'] == '' || address[i]['District'] == null) {
//         amphorName = '';
//       } else {
//         Map<String, dynamic> resultAmphure = mapList.firstWhere(
//             (element) => element['name_th'] == address[i]['District'],
//             orElse: () => {});

//         amphorName = resultAmphure['name_th'] ?? '';
//       }

//       //====================================================================
//       if (address[i]['SubDistrict'] == '' ||
//           address[i]['SubDistrict'] == null) {
//         tambonName = '';
//       } else {
//         Map<String, dynamic> resultTambon = tambonList.firstWhere(
//             (element) => element['name_th'] == address[i]['SubDistrict'],
//             orElse: () => {});
//         tambonName = resultTambon['name_th'] ?? '';
//       }
//       //====================================================================
//       addressThai.add({
//         'province_name':
//             provincesName! == '' ? provincesName : 'จ.' + provincesName,
//         'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
//         'tambon_name': tambonName! == '' ? tambonName : 'ต.' + tambonName,
//       });
//       print('Check map errorr');
//       print(addressThai);

//       //     '${address[i]['HouseNumber']} ${address[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

//       // textList[i]!.add(text.trimLeft());
//     }

//     double mapZoom = 14.4746;

//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(builder: (context, setStateMapDialog) {
//           void getLatLngFromAddress(String address) async {
//             try {
//               List<Location> locations = await locationFromAddress(address);

//               if (locations.isNotEmpty) {
//                 Location location = locations.first;
//                 print(address);
//                 print(
//                     'Latitude: ${location.latitude}, Longitude: ${location.longitude}');
//                 lat = location.latitude;
//                 lot = location.longitude;

//                 _kGooglePlexDialog = CameraPosition(
//                   target: google_maps.LatLng(lat!, lot!),
//                   zoom: 14.4746,
//                 );
//                 markersDialog.clear();
//                 markersDialog.add(
//                   Marker(
//                     markerId: MarkerId("your_marker_id"),
//                     position: google_maps.LatLng(lat!, lot!), // ตำแหน่ง
//                     infoWindow: InfoWindow(
//                       title: '_model.textController18.text', // ชื่อของปักหมุด
//                       // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
//                       onTap: () async {
//                         await mapDialog(resultList, null);
//                         _mapKey = GlobalKey();
//                         if (mounted) {
//                           setStateMapDialog(() {});
//                         }
//                       },
//                     ),
//                   ),
//                 );
//                 _mapKeyDialog = GlobalKey();

//                 if (mounted) {
//                   setStateMapDialog(() {});
//                   (() {},);
//                 }
//               } else {
//                 print('No location found for the given address');
//               }
//             } catch (e) {
//               print('Error: $e');
//               await Fluttertoast.showToast(
//                   msg: "   ไม่มีสถานที่นี้ค่ะ กรุณากรอกชื่อสถานที่ใหม่ค่ะ   ",
//                   toastLength: Toast.LENGTH_SHORT,
//                   gravity: ToastGravity.CENTER,
//                   timeInSecForIosWeb: 5,
//                   backgroundColor: Colors.red,
//                   textColor: Colors.white,
//                   fontSize: 16.0);
//             }
//           }

//           return AlertDialog(
//             actionsPadding: EdgeInsets.all(20),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             actions: [
//               SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 // height: 700,
//                 child: SingleChildScrollView(
//                   physics: ScrollPhysics(),
//                   scrollDirection: Axis.vertical,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Align(
//                         alignment: Alignment.center,
//                         child: Padding(
//                           padding: EdgeInsets.only(bottom: 8.0, top: 0.0),
//                           child: Text(
//                             "  กรุณาพิมพ์ชื่อสถานที่เพื่อบันทึกโลเคชั่นค่ะ",
//                             style: FlutterFlowTheme.of(context).headlineSmall,
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.center,
//                         child: Padding(
//                           padding: EdgeInsets.only(bottom: 0.0, top: 0.0),
//                           child: Text(
//                             "   *กรุณาเลือกที่อยู่ ให้ตรงกับสถานที่ที่คุณค้นหาค่ะ",
//                             style: FlutterFlowTheme.of(context).labelLarge,
//                           ),
//                         ),
//                       ),
//                       for (int i = 0; i < address.length; i++)
//                         SizedBox(
//                           height: 30,
//                           child: CheckboxListTile(
//                             title: Text(
//                                 '${address[i]['HouseNumber']} ${address[i]['VillageName']} ${addressThai[i]['tambon_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['province_name']} '
//                                     .trimLeft()),
//                             value: boolCheck[i],
//                             onChanged: (value) {
//                               for (int j = 0; j < boolCheck.length; j++) {
//                                 boolCheck[j] = (i == j) ? value! : false;
//                                 // print(boolCheck[j]);
//                                 if (boolCheck[j]) {
//                                   idMarkerIn = address[j]['ID'];
//                                 }
//                               }
//                               if (mounted) {
//                                 setStateMapDialog(() {});
//                               }
//                               print('change checkbox');
//                               print(boolCheck);
//                               print(idMarkerIn);
//                             },
//                             controlAffinity: ListTileControlAffinity.leading,
//                             contentPadding: EdgeInsets.only(bottom: 4),
//                           ),
//                         ),
//                       SizedBox(
//                         height: 40,
//                       ),
//                       Stack(
//                         children: [
//                           Container(
//                             width: MediaQuery.sizeOf(context).width * 1.0,
//                             height: 500.0,
//                             decoration: BoxDecoration(
//                               color: FlutterFlowTheme.of(context)
//                                   .secondaryBackground,
//                               borderRadius: BorderRadius.circular(0.0),
//                               shape: BoxShape.rectangle,
//                             ),
//                             child: GoogleMap(
//                               key: _mapKeyDialog,
//                               // onTap: (argument) async {},
//                               onTap: (argument) async {
//                                 // _mapController =
//                                 //     Completer<GoogleMapController>();
//                                 print('argument');
//                                 print(argument);
//                                 lat = argument.latitude;
//                                 lot = argument.longitude;

//                                 _kGooglePlexDialog = CameraPosition(
//                                   target: google_maps.LatLng(lat!, lot!),
//                                   zoom: mapZoom,
//                                 );

//                                 markersDialog.clear();
//                                 markersDialog.add(
//                                   Marker(
//                                     markerId: MarkerId("your_marker_id"),
//                                     position: google_maps.LatLng(
//                                         lat!, lot!), // ตำแหน่ง
//                                     infoWindow: InfoWindow(
//                                       title: _model.textController18
//                                           .text, // ชื่อของปักหมุด
//                                       // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
//                                     ),
//                                   ),
//                                 );

//                                 _mapKeyDialog = GlobalKey();
//                                 final GoogleMapController controller =
//                                     await _mapController.future;

//                                 controller.animateCamera(
//                                     CameraUpdate.newCameraPosition(
//                                         _kGooglePlexDialog));

//                                 if (mounted) {
//                                   setStateMapDialog(() {});
//                                 }
//                               },

//                               mapType: ui_maps.MapType.hybrid,
//                               initialCameraPosition: _kGooglePlexDialog,
//                               markers: markersDialog, // เพิ่มนี่
//                               onMapCreated: (GoogleMapController controller) {
//                                 _mapController.complete(controller);
//                               },
//                               onCameraMove: (CameraPosition position) {
//                                 mapZoom = position.zoom;
//                               },
//                             ),
//                           ),
//                           //=============================================================
//                           Align(
//                             alignment: Alignment.topCenter,
//                             child: Padding(
//                               padding: EdgeInsetsDirectional.fromSTEB(
//                                   30.0, 15.0, 30.0, 5.0),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                     width:
//                                         MediaQuery.sizeOf(context).width * 0.4,
//                                     height: 25.0,
//                                     decoration: BoxDecoration(
//                                       color:
//                                           FlutterFlowTheme.of(context).accent3,
//                                       borderRadius: BorderRadius.circular(8.0),
//                                     ),
//                                     alignment: AlignmentDirectional(0.00, 0.00),
//                                     child: Row(
//                                       children: [
//                                         Expanded(
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 10.0),
//                                             child: TextFormField(
//                                               controller:
//                                                   _model.textController18,
//                                               focusNode:
//                                                   _model.textFieldFocusNode18,
//                                               autofocus: false,
//                                               obscureText: false,
//                                               decoration: InputDecoration(
//                                                 isDense: true,
//                                                 labelStyle:
//                                                     FlutterFlowTheme.of(context)
//                                                         .labelMedium,
//                                                 hintText:
//                                                     '        ค้นหาสถานที่',
//                                                 hintStyle:
//                                                     FlutterFlowTheme.of(context)
//                                                         .labelMedium
//                                                         .override(
//                                                           fontFamily: 'Kanit',
//                                                           color: FlutterFlowTheme
//                                                                   .of(context)
//                                                               .primaryText,
//                                                         ),
//                                                 enabledBorder: InputBorder.none,
//                                                 focusedBorder: InputBorder.none,
//                                                 errorBorder: InputBorder.none,
//                                                 focusedErrorBorder:
//                                                     InputBorder.none,
//                                               ),
//                                               style:
//                                                   FlutterFlowTheme.of(context)
//                                                       .bodyMedium,
//                                               textAlign: TextAlign.center,
//                                               validator: _model
//                                                   .textController18Validator
//                                                   .asValidator(context),
//                                             ),
//                                           ),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () async {
//                                             getLatLngFromAddress(
//                                                 _model.textController18.text);
//                                           },
//                                           child: Icon(
//                                             Icons.search_sharp,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 25,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           TextButton(
//                               style: ButtonStyle(
//                                 shape: MaterialStateProperty.all<
//                                     RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                 ),
//                                 side: MaterialStatePropertyAll(
//                                   BorderSide(
//                                       color: Colors.red.shade300, width: 1),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: CustomText(
//                                 text: "               ยกเลิก               ",
//                                 size: MediaQuery.of(context).size.height * 0.15,
//                                 color: Colors.red.shade300,
//                               )),
//                           TextButton(
//                               style: ButtonStyle(
//                                 shape: MaterialStateProperty.all<
//                                     RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                 ),
//                                 backgroundColor: MaterialStatePropertyAll(
//                                     Colors.blue.shade900),
//                               ),
//                               onPressed: () async {
//                                 // CustomProgressDialog.show(context);
//                                 print('Map Dialog Summit');
//                                 print(lat);
//                                 print(lot);

//                                 if (lat == null && lot == null) {
//                                   Navigator.pop(context);
//                                 } else {
//                                   for (int i = 0; i < boolCheck.length; i++) {
//                                     if (boolCheck[i] == true) {
//                                       print('Get the map');
//                                       print(i);
//                                       resultList[i]['Latitude'] =
//                                           lat == null ? "" : lat.toString();
//                                       resultList[i]['Longitude'] =
//                                           lat == null ? "" : lot.toString();
//                                       latList![i].text =
//                                           lat == null ? "" : lat.toString();
//                                       lotList![i].text =
//                                           lat == null ? "" : lot.toString();

//                                       if (idMarkerIn != null) {
//                                         _kGooglePlex = CameraPosition(
//                                           target: google_maps.LatLng(
//                                               resultList[0]['Latitude'] == ''
//                                                   ? double.parse(resultList[i]
//                                                       ['Latitude']!)
//                                                   : double.parse(resultList[0]
//                                                       ['Latitude']!),
//                                               resultList[0]['Longitude'] == ''
//                                                   ? double.parse(resultList[i]
//                                                       ['Longitude']!)
//                                                   : double.parse(resultList[0]
//                                                       ['Longitude']!)),
//                                           zoom: mapZoom,
//                                         );

//                                         markerId = MarkerId(idMarkerIn!);

//                                         // ลบ Marker เดิมที่มี markerId เดียวกัน
//                                         markers.removeWhere((marker) =>
//                                             marker.markerId == markerId);

//                                         markers.add(
//                                           Marker(
//                                             markerId:
//                                                 MarkerId(resultList[i]['ID']),
//                                             position: google_maps.LatLng(
//                                                 lat!, lot!), // ตำแหน่ง
//                                             infoWindow: InfoWindow(
//                                               title:
//                                                   'จุดที่ ${i + 1}', // ชื่อของปักหมุด
//                                               snippet: resultList[i]
//                                                   ['Latitude'],
//                                               onTap: () async {
//                                                 await mapDialog(resultList,
//                                                         resultList[i]['ID'])
//                                                     .whenComplete(() {
//                                                   _mapKey = GlobalKey();
//                                                   // if (mounted) {
//                                                   //   setState(() {});
//                                                   // }
//                                                 });

//                                                 // setState(
//                                                 //   () {},
//                                                 // );
//                                               }, // คำอธิบายของปักหมุด
//                                             ),
//                                           ),
//                                         );
//                                       }

//                                       print(markers);
//                                     }
//                                   }

//                                   _model.textController18!.clear();
//                                   // _mapKeyDialog = GlobalKey();
//                                   print(resultList);

//                                   // CustomProgressDialog.hide(context);
//                                   _mapKey = GlobalKey();
//                                   _mapKeyDialog = GlobalKey();

//                                   print('3333');

//                                   await mapController2.future
//                                       .then((controller) {
//                                     controller.dispose();
//                                   });

//                                   if (mounted) {
//                                     setState(() {});
//                                   }
//                                   Navigator.pop(context);
//                                   print('5555');
//                                 }
//                               },
//                               child: CustomText(
//                                 text: "               บันทึก               ",
//                                 size: MediaQuery.of(context).size.height * 0.15,
//                                 color: Colors.white,
//                               )),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 25,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         });
//       },
//     );
//   }

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
          imageAddressAllForDropdown.clear();
          for (int i = 0; i < imageUrl.length; i++) {
            imageAddressAllForDropdown.add('รูปภาพ ${i + 1}');
          }
          for (int i = 0; i < resultList.length; i++) {
            resultList[i]['Image'] = '';
            dropDownControllersimageAddress[i].value = '';
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
    List<XFile>? images = await _picker.pickMultiImage(maxWidth: 1000);

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
          imageAddressAllForDropdown.clear();
          for (int i = 0; i < imageUrl.length; i++) {
            imageAddressAllForDropdown.add('รูปภาพ ${i + 1}');
          }
          for (int i = 0; i < resultList.length; i++) {
            resultList[i]['Image'] = '';
            dropDownControllersimageAddress[i].value = '';
          }
        });
      }
    }
  }

  Future<dynamic> imageDialog2(String text, int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
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
                        "กรุณาเลือกรูปแบบของเอกสารค่ะ",
                        style: FlutterFlowTheme.of(context).headlineMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
                      child: Text(
                        text,
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
                          pickPdfFile2(index);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              FFIcons.kpaperclipPlus,
                              color: Colors.black,
                              size: MediaQuery.of(context).size.height * 0.025,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Text(
                              'แนบไฟล์',
                              style:
                                  FlutterFlowTheme.of(context).headlineMedium,
                            ),
                          ],
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
                          _pickImageCamera2(index);
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
                          _pickImageGallery2(index);
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

  void pickPdfFile2(int index) async {
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
          finalFileResultString![index]!.add(filePath);

          fileUrlFromFirestoreList![index]!.add('');

          // finalFileResult[index]!.add();
        });
        // String pdfPath = result.files.single.path!; (ไว้สำหรับ เลือกไฟล์เดียวแบบไม่ muiti)

        // Open PDF file using open_file package
        // OpenFile.open(filePath);
      }
      print(finalFileResultString);
    }
  }

  void _pickImageCamera2(int index) async {
    // //print('camera');
    final picker2 = ImagePicker();
    final pickedFile2 = await picker2.pickImage(
      maxWidth: 1000,
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
        imageUrlFromFirestoreList2![index]!.add('');
        imageFileList2![index]!.add(pickedFile2);
        imageList2![index]!.add(File(pickedFile2.path));
        imageUint8ListList2![index]!.add(imageRead2);

        print(imageFileList2);
        print(imageList2);
        print(imageUint8ListList2);
        setState(() {});
      }
      //print(imageUrl.length);
      //print(imageLength);

      // //print(imageRead);
    }
  }

  void _pickImageGallery2(int index) async {
    //print('gallery');
    final ImagePicker _picker2 = ImagePicker();
    List<XFile>? images2 = await _picker2.pickMultiImage(maxWidth: 1000);

    if (images2.isNotEmpty) {
      //print(images.length);
      for (var element2 in images2) {
        Uint8List imageRead2 = await element2.readAsBytes();
        setState(() {
          imageUrlFromFirestoreList2![index]!.add('');
          imageFileList2![index]!.add(element2);
          imageList2![index]!.add(File(element2.path));
          imageUint8ListList2![index]!.add(imageRead2);

          print(imageFileList2);
          print(imageList2);
          print(imageUint8ListList2);
        });
      }
    }
  }

  //jak datepicker
  void bottomPicker(BuildContext context) {
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
                          _model.textController2.text =
                              DateFormat('dd').format(_selectDate);
                          _model.textController3.text =
                              DateFormat('MM').format(_selectDate); //budda
                          _model.textController4.text = (int.parse(
                                      DateFormat('yyyy').format(_selectDate)) +
                                  543)
                              .toString();

                          dateBirthday = _selectDate;
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
                  child: ScrollDatePickerCustom(
                    onDateTimeChanged: (DateTime value) {
                      setState(() {
                        _selectDate = value;
                      });
                    },
                    minimumDate: DateTime(DateTime.now().year - 150,
                        DateTime.now().month, DateTime.now().day),
                    maximumDate: DateTime(DateTime.now().year, 12, 31),
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

  //jak datepicker
  void bottomPickerToSend(BuildContext context) {
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
                          _model.textController7.text =
                              DateFormat('dd').format(_selectDate);
                          _model.textController8.text =
                              DateFormat('MM').format(_selectDate); //budda
                          _model.textController9.text = (int.parse(
                                      DateFormat('yyyy').format(_selectDate)) +
                                  543)
                              .toString();

                          dateBirthday = _selectDate;

                          int day = int.parse(_model.textController7.text);
                          int month = int.parse(_model.textController8.text);
                          int year =
                              int.parse(_model.textController9.text) - 543;
                          var check = DateTime(year, month, day, 0, 0, 0)
                              .isBefore(DateTime.now());

                          if (check == true) {
                            setState(
                              () {
                                checkTimeToSend = true;
                              },
                            );
                          } else {
                            setState(
                              () {
                                checkTimeToSend = false;
                              },
                            );
                          }
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
                  child: ScrollDatePickerCustom(
                    onDateTimeChanged: (DateTime value) {
                      setState(() {
                        _selectDate = value;
                      });
                    },
                    minimumDate: DateTime(DateTime.now().year - 1, 12, 31),
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

  //jak datepicker
  void bottomPickerCompany(BuildContext context) {
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
                          _model.textController2Company.text =
                              DateFormat('dd').format(_selectDate);
                          _model.textController3Company.text =
                              DateFormat('MM').format(_selectDate); //budda
                          _model.textController4Company.text = (int.parse(
                                      DateFormat('yyyy').format(_selectDate)) +
                                  543)
                              .toString();

                          dateBirthday = _selectDate;
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
                  child: ScrollDatePickerCustom(
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
}

class CustomProgressDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("กำลังประมวลผล..."),
            ],
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
