import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dropdown_search/flutter_dropdown_search.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:m_food/a07_account_customer/a07_02_open_account/a07021_map_widget.dart';
import 'package:m_food/a07_account_customer/a07_02_open_account/widget/dropdown_custom.dart';
import 'package:m_food/a07_account_customer/a07_02_open_account/widget/form_open_new_customer_model.dart';
import 'package:m_food/a07_account_customer/a07_02_open_account/widget/map.dart';
import 'package:m_food/a20_add_new_customer_first/widget/form_open_customer_model.dart';
import 'package:m_food/a20_add_new_customer_first/widget/map_widget.dart';
import 'package:m_food/controller/category_product_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/index.dart';
import 'package:m_food/main.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/custom_text.dart';
import 'package:m_food/widgets/format_method.dart';
import 'package:m_food/widgets/watermark_paint.dart';
import 'package:m_food/widgets/widget_service.dart';
import 'package:open_file/open_file.dart';
import 'package:photo_view/photo_view.dart';
import 'package:quickalert/quickalert.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
// import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
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
import 'package:m_food/package/scroll_date_picker_custom.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart'
    as google_maps;
import 'package:google_maps_flutter_platform_interface/src/types/ui.dart'
    as ui_maps;
import 'package:geocoding/geocoding.dart';

class FormOpenCustomerEdit extends StatefulWidget {
  final Map<String, dynamic>? entryMap;

  const FormOpenCustomerEdit({@required this.entryMap, Key? key})
      : super(key: key);

  @override
  _FormOpenCustomerEditState createState() => _FormOpenCustomerEditState();
}

class _FormOpenCustomerEditState extends State<FormOpenCustomerEdit> {
  Reference? refNew;
  List<File?>? imageAddressList = [];
  List<Uint8List?>? imageAddressUint8List = [];
  List<String> imageUrl = [];

  bool check = false;

  TextEditingController? houseNumber = TextEditingController();
  TextEditingController? nameContractAddress = TextEditingController();
  TextEditingController? phoneAddress = TextEditingController();
  TextEditingController? emailAddress = TextEditingController();
  TextEditingController? soiAddress = TextEditingController();
  TextEditingController? sakaIDAddress = TextEditingController();

  TextEditingController? moo = TextEditingController();
  TextEditingController? nameMoo = TextEditingController();
  TextEditingController? raod = TextEditingController();
  TextEditingController? province = TextEditingController();
  TextEditingController? district = TextEditingController();
  TextEditingController? subDistrict = TextEditingController();
  // TextEditingController? code = TextEditingController();

  //========================================================
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  //========================================================
  late FormOpenCustomerModel _model;
  //========================================================
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;
  final categoryProductController = Get.find<CategoryProductController>();
  RxMap<String, dynamic>? categoryProduct;
  //========================================================
  List<Completer<GoogleMapController>> _mapController = [
    Completer<GoogleMapController>()
  ];
  Completer<GoogleMapController> mapController2 =
      Completer<GoogleMapController>();

  String latitude = '';
  String longtitude = '';

  late CameraPosition _kGooglePlex;

  List<CameraPosition> _kGooglePlexDialog = [
    CameraPosition(
      target: google_maps.LatLng(13.7563309, 100.5017651),
      zoom: 14.4746,
    ),
  ];

  Set<Marker> markers = Set<Marker>();
  List<Set<Marker>> markersDialog = [Set<Marker>()];

  List<Key> _mapKeyDialog = [GlobalKey()];

  TextEditingController searchMap = TextEditingController();
  // _model.textController18 ??= TextEditingController();
  Key _mapKey = GlobalKey();
  //========================================================
  PhoneNumber number = PhoneNumber(isoCode: 'TH');
  List<PhoneNumber?>? phoneList = [PhoneNumber(isoCode: 'TH')];
  String checkID = '';
  bool checkTimeToSend = false;
  //========================================================
  bool checkSummit = false;

  //=====================================================

  List<bool> chooseCheckProvice = [false];
  List<bool> chooseCheckDistrice = [false];
  List<bool> chooseCheckSubDistrice = [false];

  List<TextEditingController?>? addressProvincesStringControllerType = [
    TextEditingController()
  ];
  List<TextEditingController?>? addressAmphuresStringControllerType = [
    TextEditingController()
  ];
  List<TextEditingController?>? addressTambonsStringControllerType = [
    TextEditingController()
  ];

  List<List<String>> provincesString = [[]];
  List<List<String>> amphuresString = [[]];
  List<List<String>> tambonsString = [[]];

  //======================================================
  // ตัวแปร ไว้เก็บค่าจาก dropdown ออกใบกำกับภาษีแต่ละที่อยู่
  List<FormFieldController<String>> dropDownControllersBillTax = [
    FormFieldController<String>('')
  ];

  List<String?> listBillTaxIndex = [];
  //=====================================================
  List<String> productTypeEmployee = [];
  // ตัวแปรเก็บ ชื่อของ กลุ่มสินค้า ทั้งหมด ในส่วนของ food
  List<String> categoryNameList = [];
  // ตัวแปร ไว้เก็บค่าจาก dropdown ตารางราคา
  List<FormFieldController<String>> dropDownControllersPriceTable = [
    FormFieldController(null)
  ];
  // List<FormFieldController<String>> dropDownControllers = [];
  List<FormFieldController<String>> dropDownControllers2 = [
    FormFieldController('')
  ];
  // ตัวแปรเก็บ ชื่อของ กลุ่มสินค้า ทั้งหมด ในส่วนของ food
  // List<String?> dropDownValues = [];
  // ตัวแปรเก็บ ชื่อของ กลุ่มสินค้า ทั้งหมด ในส่วนของ food
  List<String?> dropDownValues2 = [''];
  //ไว้ควบคุมจำนวน dropdown
  int total = 1; //จำนวนสินค้าที่ขายในปัจจุบัน
  int total2 = 1; //จำนวนกลุ่มสินค้าที่จะสั่งซื้อ

  int total3 = 1;
  List<Map<String, dynamic>> resultList = [];
  //============= สำหรับ dropdown รูปภาพที่ไว้อ้างอิงแก่่่สถานที่ร้านค้าท้งหมด =========
  List<FormFieldController<String>> dropDownControllersimageAddress = [
    FormFieldController<String>('')
  ];
  List<String> imageAddressAllForDropdown = [];

  //===================================================================
  List<FocusNode?>? textFieldFocusSaka = [FocusNode()];
  List<FocusNode?>? textFieldFocusNameSaka = [FocusNode()];
  List<FocusNode?>? textFieldFocusRoad = [FocusNode()];
  List<FocusNode?>? textFieldFocusNameContract = [FocusNode()];
  List<FocusNode?>? textFieldFocusType = [FocusNode()];
  List<FocusNode?>? textFieldFocusPhone = [FocusNode()];

  List<FocusNode?>? textFieldFocusHouseNumber = [FocusNode()];
  List<FocusNode?>? textFieldFocusHouseMoo = [FocusNode()];
  List<FocusNode?>? textFieldFocusVillageName = [FocusNode()];
  // List<String?>? textProvince = [];
  // List<String?>? textDistrict = [];
  // List<String?>? texSubDistrict = [];
  List<FocusNode?>? textFieldFocusPostalCode = [FocusNode()];
  List<FocusNode?>? textFieldFocusLatitude = [FocusNode()];
  List<FocusNode?>? textFieldFocusLongitude = [FocusNode()];

  List<FormFieldController<String>> dropDownValueControllerProvince = [
    FormFieldController<String>('')
  ];

  List<FormFieldController<String>> dropDownValueControllerDistrict = [
    FormFieldController<String>('')
  ];
  List<FormFieldController<String>> dropDownValueControllerSubDistrict = [
    FormFieldController<String>('')
  ];

  //============== ประเภทสินค้าที่ขายในปัจจุบัน =================================
  List<TextEditingController?>? productType = [TextEditingController()];
  List<String?>? productTypeFinal = [];
  List<FocusNode?>? textFieldFocusProductType = [FocusNode()];
  //===================================================================

  List<TextEditingController?>? latList = [TextEditingController()];
  List<TextEditingController?>? lotList = [TextEditingController()];

  List<String> addressAllForDropdown = [];
  List<String?> addressAllForDropdownForCheckIndex = [];

  int total4 = 1;

  List<Map<String, dynamic>> resultListSendAndBill = [];
  List<FormFieldController<String>> dropDownControllersSend = [
    FormFieldController<String>('')
  ];
  List<String> dropDownControllersSendID = [];
  List<FormFieldController<String>> dropDownControllersBill = [
    FormFieldController<String>('')
  ];
  List<TextEditingController?>? sendAndBillList = [TextEditingController()];

  List<FocusNode?>? textFieldFocusSendAndBill = [FocusNode()];

  //======================================================================
  List<String> imageUrlForDelete = [];

  List<XFile?> imageFile = [];
  List<File>? image = [];
  List<Uint8List> imageUint8List = [];
  int imageLength = 0;
  Reference? ref;
  //======================================================================
  // List<FilePickerResult?> finalFileResult = List.filled(5, null);
  List<List<String>?>? finalFileResultString = List.generate(5, (_) => []);
  Reference? ref4;

  Reference? ref5;

  //======================================================================
  List<List<XFile>?>? imageFileList2 = List.generate(5, (_) => []);
  List<List<File>?>? imageList2 = List.generate(5, (_) => []);
  List<List<Uint8List>?>? imageUint8ListList2 = List.generate(5, (_) => []);
  Reference? ref3;

  List<XFile?> imageFile2 = [];
  List<File>? image2 = [];
  List<Uint8List> imageUint8List2 = [];
  int imageLength2 = 0;
  Reference? ref2;

  List<String> imageUrlForDelete2 = [];
  List<String> imageUrl2 = [];

  //======== ไว้เช็คว่าเอกสารพร้อมทุกอันไหม ==============
  List<bool?>? fileCheck = [];
  // ถ้าเอกสารบุคคลธรรมดา [true,false,true,false,false]
  // ถ้าเอกสารนิติบุคคลมีvat [true,true,true,true,false]
  // ถ้าเอกสารนิติบุคคลไม่มีvat [true,true,false,true,false]
  //======================================================================
  //=====================================================================
  ByteData _img = ByteData(0);
  // var color = Colors.black;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  bool signConfirm = false;

  Image? imageSignToShow;

  String base64ImgSign = '';
  //=====================================================================
  ScrollController _scrollController = ScrollController();

  List<dynamic>? provinces = [];
  List<dynamic>? provincesFirst = [];

  List<String> provincesListFirst = [];
  List<dynamic>? amphuresListFirst = [];
  List<dynamic>? tambonsListFirst = [];

  List<List<dynamic>>? amphures = [[]];
  List<List<dynamic>>? tambons = [[]];

  List<Map<String, dynamic>> selected = [
    {
      'province_id': null,
      'amphure_id': null,
      'tambon_id': null,
    }
  ];

  Map<String, dynamic> selectedFirst = {
    'province_id': null,
    'amphure_id': null,
    'tambon_id': null,
  };

  List<TextEditingController?>? postalCodeController = [
    TextEditingController()
  ];

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

  //=====================================================================

  // Map<String, dynamic> selected = {
  //   'province_id': null,
  //   'amphure_id': null,
  //   'tambon_id': null,
  // };

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

  DateTime dateBirthday = DateTime.now();

  Map<String, dynamic>? value;

  void scrollDown() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void scrollUp() {
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
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

  //=====================================================================
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FormOpenCustomerModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode5 ??= FocusNode();

    _model.textController6 ??= TextEditingController();
    _model.textFieldFocusNode6 ??= FocusNode();

    _model.textController7 ??=
        TextEditingController(text: DateTime.now().day.toString());

    _model.textFieldFocusNode7 ??= FocusNode();

    _model.textController8 ??=
        TextEditingController(text: DateTime.now().month.toString());
    _model.textFieldFocusNode8 ??= FocusNode();

    _model.textController9 ??=
        TextEditingController(text: (DateTime.now().year + 543).toString());

    _model.textFieldFocusNode9 ??= FocusNode();

    _model.textController10 ??= TextEditingController();
    _model.textFieldFocusNode10 ??= FocusNode();

    _model.textController11 ??= TextEditingController();
    _model.textFieldFocusNode11 ??= FocusNode();

    _model.textController12 ??= TextEditingController();
    _model.textFieldFocusNode12 ??= FocusNode();

    _model.textController13 ??= TextEditingController();
    _model.textFieldFocusNode13 ??= FocusNode();

    _model.textController14 ??= TextEditingController();
    _model.textFieldFocusNode14 ??= FocusNode();

    _model.textController15 ??= TextEditingController();
    _model.textFieldFocusNode15 ??= FocusNode();

    _model.textController16 ??= TextEditingController();
    _model.textFieldFocusNode16 ??= FocusNode();

    _model.textController17 ??= TextEditingController();
    _model.textFieldFocusNode17 ??= FocusNode();

    _model.textController171 ??= TextEditingController();
    _model.textFieldFocusNode171 ??= FocusNode();
    _model.textController172 ??= TextEditingController();
    _model.textFieldFocusNode172 ??= FocusNode();

    _model.textController18 ??= TextEditingController();
    _model.textFieldFocusNode18 ??= FocusNode();

    _model.textController19 ??= TextEditingController();
    _model.textFieldFocusNode19 ??= FocusNode();

    _model.textController191 ??= TextEditingController();
    _model.textFieldFocusNode191 ??= FocusNode();

    _model.textController20 ??= TextEditingController();
    _model.textFieldFocusNode20 ??= FocusNode();

    _model.textController1Company ??= TextEditingController();
    _model.textFieldFocusNode1Company ??= FocusNode();
    _model.textController2Company ??= TextEditingController();
    _model.textFieldFocusNode2Company ??= FocusNode();
    _model.textController3Company ??= TextEditingController();
    _model.textFieldFocusNode3Company ??= FocusNode();
    _model.textController4Company ??= TextEditingController();
    _model.textFieldFocusNode4Company ??= FocusNode();
    _model.textController41Company ??= TextEditingController();
    _model.textFieldFocusNode41Company ??= FocusNode();
    _model.textController5Company ??= TextEditingController();
    _model.textFieldFocusNode5Company ??= FocusNode();

    loadData();
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

  void loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      value = widget.entryMap!['value'];

      print(widget.entryMap);
      print(widget.entryMap);
      print(value!['ชื่อ']);
      print(value);
      print(value);
      print(value);
      var response = await DefaultAssetBundle.of(context)
          .loadString('assets/thai_province_data.json.txt');
      var result = json.decode(response);
      provinces = result;
      provinces?.sort((a, b) {
        String nameA = a['name_th'];
        String nameB = b['name_th'];

        return nameA.compareTo(nameB);
      });

      provincesFirst = result;
      provincesFirst?.sort((a, b) {
        String nameA = a['name_th'];
        String nameB = b['name_th'];

        return nameA.compareTo(nameB);
      });

      if (value!['จังหวัด'] == '') {
      } else {
        String nameThOnly = value!['จังหวัด'].split(' - ')[0];

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

        if (value!['อำเภอ'] == '') {
        } else {
          String nameThOnlyAmphor = value!['อำเภอ'].split(' - ')[0];

          // print(nameThOnlyAmphor);
          // print(nameThOnlyAmphor);
          // print(nameThOnlyAmphor);
          // print(nameThOnlyAmphor);

          Map<String, dynamic> parentAmphor = amphuresListFirst!
              .firstWhere((item) => item['name_th'] == nameThOnlyAmphor);

          districAddress = parentAmphor['id'].toString();

          tambonsListFirst = parentAmphor['tambon'];

          if (value!['ตำบล'] == '') {
          } else {
            String nameThOnlyTambon = value!['ตำบล'].split(' - ')[0];

            Map<String, dynamic> parentTambon = tambonsListFirst!
                .firstWhere((item) => item['name_th'] == nameThOnlyTambon);

            subDistricAddress = parentTambon['id'].toString();
          }
        }
      }

      if (value!['ละติจูด'] == '') {
        _kGooglePlex = CameraPosition(
          target: google_maps.LatLng(13.7563309, 100.5017651),
          zoom: 14.4746,
        );
      } else {
        _kGooglePlex = CameraPosition(
          target: google_maps.LatLng(double.parse(value!['ละติจูด']),
              double.parse(value!['ลองติจูด'])),
          zoom: 14.4746,
        );

        markers.clear();

        markers.add(
          Marker(
            markerId: MarkerId("your_marker_id"),
            position: google_maps.LatLng(double.parse(value!['ละติจูด']),
                double.parse(value!['ลองติจูด'])),
            infoWindow: InfoWindow(
              title: searchMap.text,
            ),
          ),
        );
      }

      userData = userController.userData;

      _model.radioButtonValueController ??=
          FormFieldController<String>(value!['คำนำหน้า']);

      if (value!['PhoneTypeCountry'] == null ||
          value!['PhoneTypeCountry'] == '') {
        number = PhoneNumber(isoCode: 'TH');
      } else {
        if (value!['PhoneNumber'] == null || value!['PhoneNumber'] == '') {
          number = PhoneNumber(isoCode: 'TH');
        } else {
          number = await PhoneNumber.getRegionInfoFromPhoneNumber(
              '${value!['PhoneTypeCountry']}${value!['PhoneNumber']}', 'TH');
        }
      }

      _model.textController6 =
          TextEditingController(text: value!['PhoneNumber']);

      _model.textControllerName = TextEditingController(text: value!['ชื่อ']);

      print(_model.textControllerName.text);
      print(_model.textControllerName.text);
      print(_model.textControllerName.text);
      print(_model.textControllerName.text);
      print(_model.textControllerName.text);
      print(_model.textControllerName.text);

      _model.textControllerSurname =
          TextEditingController(text: value!['นามสกุล']);

      print(_model.textControllerSurname.text);
      print(_model.textControllerSurname.text);
      print(_model.textControllerSurname.text);
      print(_model.textControllerSurname.text);
      print(_model.textControllerSurname.text);
      print(_model.textControllerSurname.text);

      homeAddress = TextEditingController(text: value!['บ้านเลขที่']);
      nameContractAddress =
          TextEditingController(text: value!['ชื่อผู้ติดต่อ']);
      phoneAddress = TextEditingController(text: value!['เบอร์โทร']);
      emailAddress = TextEditingController(text: value!['อีเมลล์']);
      soiAddress = TextEditingController(text: value!['ซอย']);
      sakaIDAddress = TextEditingController(text: value!['รหัสสาขา']);

      mooAddress = TextEditingController(text: value!['หมู่']);
      nameMooAddress = TextEditingController(text: value!['หมู่บ้าน']);
      roadAddress = TextEditingController(text: value!['ถนน']);
      proviceAddress = TextEditingController(text: value!['จังหวัด']);
      districAddressController = TextEditingController(text: value!['อำเภอ']);

      subDistricAddressController = TextEditingController(text: value!['ตำบล']);
      nameContractAddress =
          TextEditingController(text: value!['ชื่อผู้ติดต่อ']);
      phoneAddress = TextEditingController(text: value!['เบอร์โทร']);
      emailAddress = TextEditingController(text: value!['อีเมลล์']);

      for (var element in value!['รูปภาพ']) {
        imageUrl.add(element);
        imageAddressList!.add(File(''));
        imageAddressUint8List!.add(Uint8List(0));
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
    // _mapController.isCompleted; _mapController2.isCompleted;

    super.dispose();
  }

  Future<void> trySummit(bool checkButtonSuccess) async {
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

      String signatureUrl = '';

      //================================= image ที่อยู่ ======================================

      List<String> listUrl2 = [];

      // for (int i = 0; i < imageAddressList!.length; i++) {
      //   String fileName2 =
      //       '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg';
      //   if (imageAddressList![i]!.path.isEmpty) {
      //     // listUrl.add(imageUrl[i]);
      //   } else {
      //     ref2 = FirebaseStorage.instance
      //         .ref()
      //         .child('images')
      //         .child('Users')
      //         .child(userController.userData!['UserID'])
      //         .child('ข้อมูลลูกค้าใหม่่')
      //         .child(AppSettings.customerType == CustomerType.Test
      //             ? 'CustomerTest'
      //             : 'Customer')
      //         .child(docID)
      //         .child(DateTime.now().month.toString())
      //         .child('${DateTime.now().day}/$fileName2');

      //     await ref2!.putFile(imageAddressList![i]!).whenComplete(
      //       () async {
      //         await ref2!.getDownloadURL().then(
      //           (value2) {
      //             listUrl2.add(value2);
      //           },
      //         );
      //       },
      //     );
      //   }
      // }
      List<String> listUrl = [];

      for (int i = 0; i < imageAddressList!.length; i++) {
        String fileName =
            '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg';
        if (imageAddressList![i]!.path.isEmpty) {
          listUrl.add(imageUrl[i]);
        } else {
          ref = FirebaseStorage.instance
              .ref()
              .child('images')
              .child('Users')
              .child(userController.userData!['UserID'])
              .child('ข้อมูลลูกค้าใหม่่')
              .child(AppSettings.customerType == CustomerType.Test
                  ? 'CustomerTest'
                  : 'Customer')
              .child(value!['CustomerFirstID'])
              .child(DateTime.now().month.toString())
              .child('${DateTime.now().day}/$fileName');

          await ref!.putFile(imageAddressList![i]!).whenComplete(
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

      //================================= Set to Firebase ======================================

      print('ooooo');
      print(_model.textControllerName.text);
      print(_model.textControllerSurname.text);
      // resultList.clear();
      value!['คำนำหน้า'] = _model.radioButtonValueController == null
          ? ''
          : _model.radioButtonValueController!.value!;
      // 'PhoneTypeCountry': number.dialCode,
      // 'PhoneNumber': _model.textController6.text,

      value!['ชื่อ'] = _model.textControllerName.text;
      value!['นามสกุล'] = _model.textControllerSurname.text;
      value!['รหัสสาขา'] = sakaIDAddress.text;
      value!['บ้านเลขที่'] = homeAddress.text;
      value!['หมู่'] = mooAddress.text;
      value!['หมู่บ้าน'] = nameMooAddress.text;
      value!['ถนน'] = roadAddress.text;
      value!['ซอย'] = soiAddress.text;
      value!['จังหวัด'] = proviceAddress.text;
      value!['อำเภอ'] = districAddressController.text;
      value!['ตำบล'] = subDistricAddressController.text;

      await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'ข้อมูลลูกค้าใหม่ตัวเทส'
              : 'ข้อมูลลูกค้าใหม่')
          .doc(value!['CustomerFirstID'])
          .update({
        // 'CustomerFirstID': value!['CustomerFirstID'],
        'PhoneID': _model.textController6.text,
        'CustomerDateCreate': DateTime.now(),
        'CustomerDateUpdate': DateTime.now(),
        'คำนำหน้า': _model.radioButtonValueController == null
            ? ''
            : _model.radioButtonValueController!.value,
        'PhoneTypeCountry': number.dialCode,
        'PhoneNumber': _model.textController6.text,
        'ชื่อนามสกุล':
            '${_model.textControllerName.text} ${_model.textControllerSurname.text}',
        'ชื่อ': _model.textControllerName.text,
        'นามสกุล': _model.textControllerSurname.text,
        'รหัสสาขา': sakaIDAddress.text,
        'บ้านเลขที่': homeAddress.text,
        'หมู่': mooAddress.text,
        'หมู่บ้าน': nameMooAddress.text,
        'ถนน': roadAddress.text,
        'ซอย': soiAddress.text,
        'จังหวัด': proviceAddress.text,
        'อำเภอ': districAddressController.text,
        'ตำบล': subDistricAddressController.text,
        'รหัสไปรษณีย์': codeAddress.text,
        'ชื่อผู้ติดต่อ': nameContractAddress.text,
        'เบอร์โทร': phoneAddress.text,
        'อีเมลล์': emailAddress.text,
        'วันเริ่มจัดส่ง': _model.textController7.text,
        'เดือนเริ่มจัดส่ง': _model.textController8.text,
        'ปีเริ่มจัดส่ง': _model.textController9.text,
        'ลายเซ็น': signatureUrl,
        'UserId': userController.userData!['UserID'],
        'ละติจูด': latitude,
        'ลองติจูด': longtitude,
        'รูปภาพ': listUrl,
      }).then((value) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<String> saveSignatureToFirestorePDPA(
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
        .child('ข้อมูลลูกค้าใหม่่')
        .child('CustomerSignatures')
        .child('PDPA')
        .child(docID)
        .child('signatures/$fileName');
    UploadTask uploadTask = storageReference.putData(bytes);
    print('111');
    await uploadTask.whenComplete(() => null);
    print('321');

    // Get the URL of the uploaded image
    String downloadURL = await storageReference.getDownloadURL();
    print('123');
    print(downloadURL);

    return downloadURL;
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
        .child('ข้อมูลลูกค้าใหม่่')
        .child('CustomerSignatures')
        .child(docID)
        .child('signatures/$fileName');
    UploadTask uploadTask = storageReference.putData(bytes);
    print('111');
    await uploadTask.whenComplete(() => null);
    print('321');

    // Get the URL of the uploaded image
    String downloadURL = await storageReference.getDownloadURL();
    print('123');
    print(downloadURL);

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
    // // print(documentSnapshot);
    // Map<String, dynamic> userMap =
    //     documentSnapshot.data() as Map<String, dynamic>;

    // List<dynamic> data = userMap['EmployeeAppointment'];

    // // int index = data.indexWhere((item) =>
    // //     item['CustomerPhone'] == widget.data!['CustomerPhone'] &&
    // //     item['Number'] == widget.data!['Number']);

    // int index = 0;

    // // print(userMap['EmployeeAppointment'][index]);
    // if (index != -1) {
    //   data[index]['CustomerPDPAImg'] = downloadURL;
    //   data[index]['CustomerPdpaConfirm'] = true;
    // } else {
    //   print('Item with phone number and number  not found.');
    // }
    // // print(userMap['EmployeeAppointment'][index]);
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

    // print('Signature saved to Firestore: $downloadURL');
    // showImageDialog(context, downloadURL);
  }

  @override
  Widget build(BuildContext context) {
    print('==============================');
    print('This is Form  Customer ');
    print('==============================');

    return isLoading
        ? Container(
            child: Center(
              child: CircularLoading(success: !isLoading),
            ),
          )
        : Column(
            children: [
              Form(
                key: _formKey,
                child: SizedBox(
                  height: 1000,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          //======================= checkbox คำนำหน้า ======================================
                          headNameWidget(context),
                          //=========================== ชื่อ นามสกุล /ชื่อบริษัn==================================
                          Row(
                            children: [
                              Expanded(child: namePersanal(context)),
                              Expanded(child: surnamePersanal(context)),
                            ],
                          ),

                          //===================== เบอร์โทรศัพท์ ========================================
                          phoneWidget(context),

                          sakaIDFirst(context),
                          SizedBox(
                            height: 10,
                          ),

                          houseNumberFirst(context),
                          SizedBox(
                            height: 10,
                          ),
                          mooFirst(context),
                          SizedBox(
                            height: 10,
                          ),

                          nameMooFirst(context),
                          SizedBox(
                            height: 10,
                          ),

                          roadFirst(context),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          soiFirst(context),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: dropdownProvince(
                              list: provinces,
                              child: 'amphure',
                            ),
                          ),
                          // SizedBox(height: 10.0),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: dropdownAmphor(
                              list: amphuresListFirst,
                              child: 'tambon',
                            ),
                          ),
                          // SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: dropdownTambon(
                              list: tambonsListFirst,
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

                          codeFirst(context),
                          SizedBox(
                            height: 5,
                          ),

                          //===================== วัน / เดือน / ปี ที่เริ่มจัดส่ง  ========================================

                          dateToFirstSendWidget(),
                          SizedBox(
                            height: 10,
                          ),
                          nameContractFirst(context),
                          SizedBox(
                            height: 10,
                          ),
                          phoneFirst(context),
                          SizedBox(
                            height: 10,
                          ),
                          emailFirst(context),
                          SizedBox(
                            height: 10,
                          ),
                          mapList(),
                          SizedBox(
                            height: 10,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).accent3,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 10.0, 10.0, 10.0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                          // width:
                                          //     MediaQuery.of(context).size.width * 0.9,

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
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 0, 0, 0),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    imageAddressUint8List!
                                                        .length,
                                                itemBuilder: (context, indexj) {
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 10, 0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Stack(
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () =>
                                                                  showCupertinoDialog(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        true,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return Container(
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            imageAddressUint8List![indexj] == null || imageAddressUint8List![indexj]!.isEmpty
                                                                                ? PhotoView(
                                                                                    // imageProvider: FileImage(images),
                                                                                    imageProvider: NetworkImage(imageUrl[indexj]),
                                                                                    // imageProvider: NetworkImage('URL ของรูปภาพ'),
                                                                                  )
                                                                                : PhotoView(
                                                                                    // imageProvider: FileImage(images),
                                                                                    imageProvider: MemoryImage(imageAddressUint8List![indexj]!),
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
                                                                  ),
                                                              child: imageAddressUint8List![
                                                                              indexj] ==
                                                                          null ||
                                                                      imageAddressUint8List![
                                                                              indexj]!
                                                                          .isEmpty
                                                                  ? Image
                                                                      .network(
                                                                      imageUrl[
                                                                          indexj],
                                                                      width: (MediaQuery.of(context).size.width *
                                                                              0.63) /
                                                                          4.5,
                                                                      height:
                                                                          100.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : Image
                                                                      .memory(
                                                                      imageAddressUint8List![
                                                                          indexj]!,
                                                                      width: (MediaQuery.of(context).size.width *
                                                                              0.63) /
                                                                          4.5,
                                                                      height:
                                                                          100.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )),
                                                          Positioned(
                                                            right: 0,
                                                            bottom: 0,
                                                            child: Container(
                                                              width: 20,
                                                              height: 15,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 2),
                                                                child: Text(
                                                                  '${indexj + 1}/${imageAddressList!.length}',
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      // fontSize: (lang ==
                                                                      //         'my')
                                                                      //     ? 10
                                                                      //     : 10),
                                                                      fontSize: 10),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
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
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.2),
                                                                    spreadRadius:
                                                                        1,
                                                                    blurRadius:
                                                                        1,
                                                                    offset:
                                                                        Offset(
                                                                      0,
                                                                      1,
                                                                    ), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              child:
                                                                  GestureDetector(
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                onTap: () {
                                                                  imageUrl
                                                                      .removeAt(
                                                                          indexj);

                                                                  imageAddressUint8List!
                                                                      .removeAt(
                                                                          indexj);

                                                                  imageAddressList!
                                                                      .removeAt(
                                                                          indexj);

                                                                  setState(
                                                                      () {});
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
                                                      imageAddressUint8List!
                                                          .length;
                                                  i--)
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          5.0, 0.0, 5.0, 0.0),
                                                  child: Container(
                                                    width:
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.63) /
                                                            4.5,
                                                    height: 100.0,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                    child: Icon(
                                                      FFIcons.kimagePlus,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 40.0,
                                                    ),
                                                  ),
                                                ),
                                              InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        // title: Text('Dialog Title'),
                                                        // content: Text('This is the dialog content.'),
                                                        actionsPadding:
                                                            EdgeInsets.all(20),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                        ),
                                                        actions: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      bottom:
                                                                          8.0,
                                                                      top: 5.0),
                                                                  child: Text(
                                                                    "กรุณาเลือกรูปแบบของรูปภาพค่ะ",
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
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
                                                                    onTap:
                                                                        () async {
                                                                      Navigator.pop(
                                                                          context);
                                                                      // //print('camera');
                                                                      final picker =
                                                                          ImagePicker();
                                                                      final pickedFile =
                                                                          await picker
                                                                              .pickImage(
                                                                        maxWidth:
                                                                            1000,
                                                                        source:
                                                                            ImageSource.camera, // ใช้กล้องถ่ายรูป
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
                                                                            imageFileCrop.path,
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
                                                                              toolbarTitle: 'Cropper',
                                                                              toolbarColor: Colors.deepOrange,
                                                                              toolbarWidgetColor: Colors.white,
                                                                              initAspectRatio: CropAspectRatioPreset.original,
                                                                              lockAspectRatio: false),
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
                                                                              await croppedFile.readAsBytes();

                                                                          imageAddressUint8List!
                                                                              .add(imageRead);

                                                                          XFile?
                                                                              pickedFileForFirebase =
                                                                              XFile(croppedFile.path);
                                                                          imageAddressList!
                                                                              .add(File(pickedFileForFirebase.path));

                                                                          if (mounted) {
                                                                            setState(() {});
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
                                                                          color:
                                                                              Colors.black,
                                                                          size: MediaQuery.of(context).size.height *
                                                                              0.025,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.03,
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
                                                                    onTap:
                                                                        () async {
                                                                      Navigator.pop(
                                                                          context);
                                                                      //print('gallery');
                                                                      final ImagePicker
                                                                          _picker =
                                                                          ImagePicker();
                                                                      List<XFile>?
                                                                          images =
                                                                          await _picker.pickMultiImage(
                                                                              maxWidth: 1000);

                                                                      if (images
                                                                          .isNotEmpty) {
                                                                        //print(images.length);
                                                                        for (var element
                                                                            in images) {
                                                                          Uint8List
                                                                              imageRead =
                                                                              await element.readAsBytes();

                                                                          imageAddressUint8List!
                                                                              .add(imageRead);

                                                                          imageAddressList!
                                                                              .add(File(element.path));

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
                                                                          color:
                                                                              Colors.black,
                                                                          size: MediaQuery.of(context).size.height *
                                                                              0.025,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.03,
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
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    TextButton(
                                                                        style:
                                                                            ButtonStyle(
                                                                          shape:
                                                                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10.0), // ปรับค่าตามต้องการ
                                                                            ),
                                                                          ),
                                                                          side:
                                                                              MaterialStatePropertyAll(
                                                                            BorderSide(
                                                                                color: Colors.red.shade300,
                                                                                width: 1),
                                                                          ),
                                                                        ),
                                                                        onPressed: () =>
                                                                            Navigator.pop(
                                                                                context),
                                                                        child:
                                                                            CustomText(
                                                                          text:
                                                                              "   ยกเลิก   ",
                                                                          size: MediaQuery.of(context).size.height *
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
                                                        BorderRadius.circular(
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
                                                            Colors.black,
                                                        child: Icon(
                                                          FFIcons
                                                              .kpaperclipPlus,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                          // imageThree(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //========================== เซฟไว้ทำทีหลัง  ===================================
              saveButton(context),
              sendButton(context),
              //========================== เซฟแล้วดำเนินการต่อไป  ===================================
              // Padding(
              //   padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 0.0),
              //   child: confirmButton(context),
              // ),
            ],
          );
  }

  Padding sendButton(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
      child: FFButtonWidget(
        onPressed: () async {
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
          await trySummit(true).whenComplete(() => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => A0702OpenAccountWidget(
                  value: value!,
                ),
              )));
        },
        text: 'ส่งข้อมูลเปิดหน้าบัญชีลูกค้า',
        options: FFButtonOptions(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: 40.0,
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: Colors.green.shade900,
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
        onPressed: () async {
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
          await trySummit(true).whenComplete(() => Navigator.pop(context));
        },
        text: 'บันทึกข้อมูล',
        options: FFButtonOptions(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: 40.0,
          padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
          color: Colors.blue.shade900,
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

  Padding imageThree(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => showPreviewImage(2, 'memory'),
              child: Image.memory(
                imageUint8List[2],
                width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
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
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '${2 + 1}/${imageFile.length}',
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
                    imageUint8List.removeAt(2);
                    imageFile.removeAt(2);
                    image!.removeAt(2);
                    imageUrl.removeAt(2);
                    imageLength = imageLength - 1;

                    imageAddressAllForDropdown.clear();
                    for (int i = 0; i < imageUrl.length; i++) {
                      imageAddressAllForDropdown.add('รูปภาพ ${i + 1}');
                    }
                    for (int i = 0; i < resultList.length; i++) {
                      resultList[i]['Image'] = '';
                      dropDownControllersimageAddress[i].value = '';
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
    );
  }

  Widget mapList() {
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
                  key: _mapKey,
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
                        builder: (context) => MapWidgetFirst(
                            latitude: latitude, longtitude: longtitude),
                      ),
                    );
                    // อัปเดต State ด้วยค่าที่ส่งกลับมา
                    print(result!['latitudeToBack']);
                    print(result['longitudeToBack']);

                    latitude = result['latitudeToBack'].toString();

                    longtitude = result['longitudeToBack'].toString();

                    print(latitude);
                    print(longtitude);

                    double? lat = result['latitudeToBack'];
                    double? lot = result['longitudeToBack'];
                    _kGooglePlex = CameraPosition(
                      target: google_maps.LatLng(lat!, lot!),
                      zoom: mapZoom,
                    );

                    markers.clear();

                    markers.add(
                      Marker(
                        markerId: MarkerId("your_marker_id"),
                        position: google_maps.LatLng(lat, lot),
                        infoWindow: InfoWindow(
                          title: searchMap.text,
                        ),
                      ),
                    );

                    _mapKey = GlobalKey();
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
                  initialCameraPosition: _kGooglePlex,
                  markers: markers, // เพิ่มนี่
                  onMapCreated: (GoogleMapController controller) {
                    mapController2.complete(controller);
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
  // Align mapWidget(BuildContext context) {
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
  //                         if (mounted) {
  //                           setStateMap(
  //                             () {
  //                               loadMap = true;
  //                             },
  //                           );
  //                         }

  //                         print('After Dialog Map');
  //                         print(resultList[0]['Latitude']);
  //                         late double lat;
  //                         late double lot;

  //                         if (resultList[0]['Latitude'] == '' ||
  //                             resultList[0]['Longitude'] == '') {
  //                           for (int i = 0; i < resultList.length; i++) {
  //                             if (resultList[i]['Latitude'] != '' &&
  //                                 resultList[i]['Longitude'] != '') {
  //                               lat = double.parse(resultList[i]['Latitude']);
  //                               lot = double.parse(resultList[i]['Longitude']);
  //                               break;
  //                             } else {
  //                               lat = 13.7563309;
  //                               lot = 100.5017651;
  //                             }
  //                           }
  //                         } else {
  //                           lat = double.parse(resultList[0]['Latitude']);
  //                           lot = double.parse(resultList[0]['Longitude']);
  //                         }

  //                         print(lat);
  //                         print(lot);
  //                         _kGooglePlex = CameraPosition(
  //                           target: google_maps.LatLng(lat, lot),
  //                           zoom: 15,
  //                         );
  //                         markers.clear();

  //                         for (int i = 0; i < resultList.length; i++) {
  //                           if (resultList[i]['Latitude'] == '') {
  //                           } else {
  //                             double latIndex =
  //                                 double.parse(resultList[i]['Latitude']);
  //                             double lotIndex =
  //                                 double.parse(resultList[i]['Longitude']!);
  //                             print('hhhhhhhhhh');
  //                             print(resultList[i]['ID']);
  //                             // print(resultList[i]['Latitude']);
  //                             // print(resultList[i]['Longitude']);
  //                             print('hhhhhhhhhh');

  //                             markers.add(
  //                               Marker(
  //                                 markerId: MarkerId(resultList[i]['ID']),
  //                                 position: google_maps.LatLng(
  //                                     latIndex, lotIndex), // ตำแหน่ง
  //                                 infoWindow: InfoWindow(
  //                                   title: 'จุดที่ ${i + 1}', // ชื่อของปักหมุด
  //                                   snippet: resultList[i]['Latitude'],
  //                                   onTap: () async {
  //                                     print('6666');
  //                                     _mapKey = GlobalKey();
  //                                     print('7777');
  //                                     if (mounted) {
  //                                       setState(() {});
  //                                     }
  //                                     print('88888');

  //                                     //     .whenComplete(() {
  //                                     //   setState(
  //                                     //     () {
  //                                     //       loadMap = true;
  //                                     //     },
  //                                     //   );

  //                                     //   return;

  //                                     // });
  //                                   }, // คำอธิบายของปักหมุด
  //                                 ),
  //                               ),
  //                             );
  //                             print('pppp');
  //                           }
  //                         }

  //                         _mapKey = GlobalKey();

  //                         print('after add map');
  //                         print(_kGooglePlex);
  //                         print(markers);

  //                         if (mounted) {
  //                           setStateMap(
  //                             () {
  //                               loadMap = false;
  //                             },
  //                           );
  //                         }
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

  Padding dateToFirstSendWidget() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
      child: StatefulBuilder(builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            checkTimeToSend
                ? Text('!! กรุณากรอกวันที่ไม่น้อยกว่าวันที่ปัจจุบันค่ะ',
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
                    'วันที่เก็บข้อมูล',
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

                          // var check = DateTime(year, month, day).isBefore(
                          //     DateTime.now().subtract(Duration(
                          //         hours: DateTime.now().hour,
                          //         minutes: DateTime.now().minute,
                          //         seconds: DateTime.now().second,
                          //         milliseconds: DateTime.now().millisecond,
                          //         microseconds: DateTime.now().microsecond)));

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
                          // var check = DateTime(year, month, day).isBefore(
                          //     DateTime.now().subtract(Duration(
                          //         hours: DateTime.now().hour,
                          //         minutes: DateTime.now().minute,
                          //         seconds: DateTime.now().second,
                          //         milliseconds: DateTime.now().millisecond,
                          //         microseconds: DateTime.now().microsecond)));

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

                          // var check = DateTime(year, month, day).isBefore(
                          //     DateTime.now().subtract(Duration(
                          //         hours: DateTime.now().hour,
                          //         minutes: DateTime.now().minute,
                          //         seconds: DateTime.now().second,
                          //         milliseconds: DateTime.now().millisecond,
                          //         microseconds: DateTime.now().microsecond)));

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

  Padding phoneWidget(BuildContext context) {
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

  //================================================================================================

  Padding sakaIDFirst(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            check = false;
          });
        },
        controller: sakaIDAddress,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'รหัสสาขา',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'รหัสสาขา',
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

  Padding houseNumberFirst(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            check = false;
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

  Padding soiFirst(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        controller: soiAddress,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'ซอย',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'ซอย',
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

  Padding phoneFirst(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        controller: phoneAddress,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'เบอร์โทรผู้ติดต่อ',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'เบอร์โทรผู้ติดต่อ',
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

  Padding nameContractFirst(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        controller: nameContractAddress,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'ชื่อผู้ติดต่อ',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'ชื่อผู้ติดต่อ',
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

  Padding emailFirst(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
      child: TextFormField(
        controller: emailAddress,
        autofocus: false,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'อีเมลล์',
          isDense: true,
          labelStyle: FlutterFlowTheme.of(context).labelMedium,
          hintText: 'อีเมลล์',
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

  Padding headNameWidget(BuildContext context) {
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
                      imageProvider: NetworkImage(imageUrl2[index]),
                    )
                  : PhotoView(
                      // imageProvider: FileImage(images),
                      imageProvider:
                          MemoryImage(imageUint8ListList2![indexList]![index]),
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
//     } else {
//       for (int i = 0; i < address.length; i++) {
//         if (address[i]['ID'] == idMarkerIn) {
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
//               print(address);

//               print(locations);

//               if (locations.isNotEmpty) {
//                 Location location = locations.first;
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
//                   setStateMapDialog(
//                     () {},
//                   );
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

//                                     // '${address[i]['HouseNumber']} ${address[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']} '
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
//                                             print(_model.textController18.text);
//                                             print('search button');
//                                             getLatLngFromAddress(
//                                                 _model.textController18.text);
//                                             print('search button');
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
        imageAddressAllForDropdown.clear();
        for (int i = 0; i < imageUrl.length; i++) {
          imageAddressAllForDropdown.add('รูปภาพ ${i + 1}');
        }

        for (int i = 0; i < resultList.length; i++) {
          resultList[i]['Image'] = '';
          dropDownControllersimageAddress[i].value = '';
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
        imageAddressAllForDropdown.clear();
        for (int i = 0; i < imageUrl.length; i++) {
          imageAddressAllForDropdown.add('รูปภาพ ${i + 1}');
        }
        for (int i = 0; i < resultList.length; i++) {
          resultList[i]['Image'] = '';
          dropDownControllersimageAddress[i].value = '';
        }
        setState(() {});
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

        imageFileList2![index]!.add(pickedFile2);
        imageList2![index]!.add(File(pickedFile2.path));
        imageUint8ListList2![index]!.add(imageRead2);

        print(imageFileList2);
        print(imageList2);
        print(imageUint8ListList2);
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

  void _pickImageGallery2(int index) async {
    //print('gallery');
    final ImagePicker _picker2 = ImagePicker();
    List<XFile>? images2 = await _picker2.pickMultiImage(maxWidth: 1000);

    if (images2.isNotEmpty) {
      //print(images.length);
      for (var element2 in images2) {
        Uint8List imageRead2 = await element2.readAsBytes();
        setState(() {
          imageFileList2![index]!.add(element2);
          imageList2![index]!.add(File(element2.path));
          imageUint8ListList2![index]!.add(imageRead2);

          print(imageFileList2);
          print(imageList2);
          print(imageUint8ListList2);

          //=============================================================
          if (imageUrl2.length > imageLength2) {
            imageUint8List2[imageLength2] = imageRead2;
            imageFile2[imageLength2] = element2;
            image2![imageLength2] = File(element2.path);
            imageUrl2[imageLength2] = '';
            imageLength2 = imageLength2 + 1;
          } else {
            imageUint8List2.add(imageRead2);
            imageFile2.add(element2);
            image2!.add(File(element2.path));
            imageUrl2.add('');
            imageLength2 = imageLength2 + 1;
          }
        });
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
                          // var check = DateTime(year, month, day, 0, 0, 0)
                          //     .isBefore(DateTime.now());

                          var check = DateTime(year, month, day).isBefore(
                              DateTime.now().subtract(Duration(
                                  hours: DateTime.now().hour,
                                  minutes: DateTime.now().minute,
                                  seconds: DateTime.now().second,
                                  milliseconds: DateTime.now().millisecond,
                                  microseconds: DateTime.now().microsecond)));

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
