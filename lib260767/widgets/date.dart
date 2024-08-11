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
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_food/components/form_general_user_widget.dart';
import 'package:m_food/components/form_general_user_widget_jak.dart';
import 'package:m_food/controller/category_product_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:m_food/widgets/custom_text.dart';
import 'package:m_food/widgets/watermark_paint.dart';
import 'package:open_file/open_file.dart';
import 'package:photo_view/photo_view.dart';
import 'package:quickalert/quickalert.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
// import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../widgets/format_method.dart';
import '../widgets/widget_service.dart';
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
import 'package:google_maps_flutter_platform_interface/src/types/location.dart' as google_maps;

import 'package:google_maps_flutter_platform_interface/src/types/ui.dart' as ui_maps;
import 'package:geocoding/geocoding.dart';

class FormGeneralUserWidget extends StatefulWidget {
  final List<bool>? quizPDPA;
  final List<String>? finalFileResultStringPDPA;
  final String? base64ImgSignPDPA;
  final String? type;
  const FormGeneralUserWidget(
      {@required this.type, @required this.base64ImgSignPDPA, @required this.finalFileResultStringPDPA, @required this.quizPDPA, Key? key})
      : super(key: key);

  @override
  _FormGeneralUserWidgetState createState() => _FormGeneralUserWidgetState();
}

class _FormGeneralUserWidgetState extends State<FormGeneralUserWidget> {
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;
  late FormGeneralUserModel _model;

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  final Completer<GoogleMapController> _mapController2 = Completer<GoogleMapController>();
  late CameraPosition _kGooglePlex;

  Set<Marker> markers = Set<Marker>();

  final _formKey = GlobalKey<FormState>();
  Key _mapKey = GlobalKey();

  final categoryProductController = Get.find<CategoryProductController>();
  RxMap<String, dynamic>? categoryProduct;
  bool isLoading = false;

  // @override
  // void setState(VoidCallback callback) {
  //   super.setState(callback);
  //   _model.onUpdate();
  // }

  String checkID = '';
  //========================================================
  bool checkSummit = false;
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
  //============= สำหรับ dropdown รูปภาพที่ไว้อ้างอิงแก่่่สถานที่ร้านค้าท้งหมด =========
  List<FormFieldController<String>> dropDownControllersimageAddress = [FormFieldController<String>('')];
  List<String> imageAddressAllForDropdown = [];

  //===================================================================
  List<FocusNode?>? textFieldFocusSaka = [FocusNode()];
  List<FocusNode?>? textFieldFocusNameSaka = [FocusNode()];
  List<FocusNode?>? textFieldFocusRoad = [FocusNode()];
  List<FocusNode?>? textFieldFocusNameContract = [FocusNode()];
  List<FocusNode?>? textFieldFocusType = [FocusNode()];
  List<FocusNode?>? textFieldFocusPhone = [FocusNode()];

  List<FocusNode?>? textFieldFocusHouseNumber = [FocusNode()];
  List<FocusNode?>? textFieldFocusVillageName = [FocusNode()];
  // List<String?>? textProvince = [];
  // List<String?>? textDistrict = [];
  // List<String?>? texSubDistrict = [];
  List<FocusNode?>? textFieldFocusPostalCode = [FocusNode()];
  List<FocusNode?>? textFieldFocusLatitude = [FocusNode()];
  List<FocusNode?>? textFieldFocusLongitude = [FocusNode()];

  List<FormFieldController<String>> dropDownValueControllerProvince = [FormFieldController<String>('')];

  List<FormFieldController<String>> dropDownValueControllerDistrict = [FormFieldController<String>('')];
  List<FormFieldController<String>> dropDownValueControllerSubDistrict = [FormFieldController<String>('')];

  //============== ประเภทสินค้าที่ขายในปัจจุบัน =================================
  List<TextEditingController?>? productType = [TextEditingController()];
  List<String?>? productTypeFinal = [];
  List<FocusNode?>? textFieldFocusProductType = [FocusNode()];
  //===================================================================

  List<TextEditingController?>? latList = [TextEditingController()];
  List<TextEditingController?>? lotList = [TextEditingController()];

  List<String> addressAllForDropdown = [];

  int total4 = 1;

  List<Map<String, dynamic>> resultListSendAndBill = [];
  List<FormFieldController<String>> dropDownControllersSend = [FormFieldController<String>('')];
  List<FormFieldController<String>> dropDownControllersBill = [FormFieldController<String>('')];
  List<TextEditingController?>? sendAndBillList = [TextEditingController()];

  List<FocusNode?>? textFieldFocusSendAndBill = [FocusNode()];

  //=====================================================

  //======================================================================
  List<String> imageUrlForDelete = [];
  List<String> imageUrl = [];
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

  List<dynamic>? provinces = [];
  List<List<dynamic>>? amphures = [[]];
  List<List<dynamic>>? tambons = [[]];

  List<Map<String, dynamic>> selected = [
    {
      'province_id': null,
      'amphure_id': null,
      'tambon_id': null,
    }
  ];
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

  void setAmphures(List<dynamic>? newAmphures, int index) {
    // print(index);
    // print('----amphor');
    // print(newAmphures);
    setState(() {
      amphures![index] = newAmphures!;
    });
  }

  void setTambons(List<dynamic>? newTambons, int index) {
    // print('----tambon');
    // print(newTambons);
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
    // print('fdsfedsfesedfewdfwe');
    // print(list);
    return StatefulBuilder(builder: (context, setState) {
      void onChangeHandle(String? selectedValue) {
        // print(';;;;;');
        // print(selectedValue);
        // print(setChilds);
        // print('eeeee');
        setChilds == null ? null : setChilds!.forEach((setChild) => setChild([], index!));
        // print('llll');
        // print(setChilds);
        Map<String, dynamic> unSelectChilds;
        setChilds == null ? unSelectChilds = {} : unSelectChilds = Map.fromIterable(childsId!, key: (item) => item, value: (item) => null);
        // print(childsId);
        // print(unSelectChilds);
        int? dependId = selectedValue!.isNotEmpty ? int.parse(selectedValue) : null;
        // print(selectedValue);
        // print(selected[index!]);
        setState(() {
          selected[index!] = {
            ...selected[index],
            ...unSelectChilds,
            id!: dependId,
          };
          // print(selected[index!]);
          // print(selected);

          // print('tttttt');
          // print(selected);

          // print(index);
          // print(resultList[index]['Province']);
          // print(resultList[index]['District']);
          // print(resultList[index]['SubDistrict']);
        });

        if (selectedValue.isEmpty) return;

        if (child != null) {
          Map<String, dynamic> parent = list!.firstWhere((item) => item['id'] == dependId);
          // print('pppppppppppp');
          // print(parent);
          List<dynamic> childs = parent[child];
          setChilds!.first(childs, index!);
        }

        label == 'Province: '
            ? resultList[index!]['Province'] = selected[index]['province_id']
            : label == 'District: '
                ? resultList[index!]['District'] = selected[index]['amphure_id']
                : resultList[index!]['SubDistrict'] = selected[index]['tambon_id'];

        print(resultList);

        addressAllForDropdown.clear();

        setState(() {
          // for (int i = 0; i < resultList.length; i++) {
          //   // รวมข้อมูลจากทุก field ในแต่ละ map เป็น string เดียว
          //   String combinedFields = resultList[i].values.join(' ');

          //   // นำ string ไปแทนที่ใน list options
          //   addressAllForDropdown.add('$combinedFields');
          // }
          //====================================================================
          List<Map<String, dynamic>> addressThai = [];

          // List<String?>? textList = [];
          for (int i = 0; i < resultList.length; i++) {
            // resultList.add(false);

            List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

            List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
            List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
            String? provincesName;
            String? amphorName;
            String? tambonName;

            //====================================================================
            if (resultList[i]['Province'] == '' || resultList[i]['Province'] == null) {
              provincesName = '';
            } else {
              Map<String, dynamic> resultProvince =
                  mapProvincesList.firstWhere((element) => element['id'] == resultList[i]['Province'], orElse: () => {});

              provincesName = resultProvince['name_th'] ?? '';
            }
            //====================================================================
            if (resultList[i]['District'] == '' || resultList[i]['District'] == null) {
              amphorName = '';
            } else {
              Map<String, dynamic> resultAmphure = mapList.firstWhere((element) => element['id'] == resultList[i]['District'], orElse: () => {});

              amphorName = resultAmphure['name_th'] ?? '';
            }

            //====================================================================
            if (resultList[i]['SubDistrict'] == '' || resultList[i]['SubDistrict'] == null) {
              tambonName = '';
            } else {
              Map<String, dynamic> resultTambon = tambonList.firstWhere((element) => element['id'] == resultList[i]['SubDistrict'], orElse: () => {});
              tambonName = resultTambon['name_th'] ?? '';
            }
            //====================================================================
            addressThai.add({
              'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
              'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
              'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
            });

            print(addressThai);

            String texttt =
                '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

            // textList[i]!.add(text.trimLeft());
            addressAllForDropdown.add(texttt.trimLeft());
          }
        });

        toSetState();
        print(selected);
      }

      return Row(
        children: [
          Expanded(
            child: Container(
              height: 55.0,
              decoration: BoxDecoration(
                border: Border.all(color: FlutterFlowTheme.of(context).alternate, width: 2),
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

  //=====================================================================
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FormGeneralUserModel());

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

    _model.textController7 ??= TextEditingController();
    _model.textFieldFocusNode7 ??= FocusNode();

    _model.textController8 ??= TextEditingController();
    _model.textFieldFocusNode8 ??= FocusNode();

    _model.textController9 ??= TextEditingController();
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

  void loadData() async {
    // context.watch<FFAppState>();
    try {
      setState(() {
        isLoading = true;
      });
      print('========== loadedddddd');
      resultList.add({
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
        'โทรศัพท์': '', //new
      });

      resultListSendAndBill.add({
        'ที่อยู่จัดส่ง': '',
        'ชื่อออกบิล': '',
        'ที่อยู่ออกบิล': '',
      });

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
      categoryProduct = categoryProductController.categoryProductsData;
      print('=================load Data ========================  ');
      print(categoryProduct!['key0']['food'][0]);

      dropDownControllers = List.generate(categoryProduct!['key0']['food'].length, (_) => FormFieldController<String>(null));
      dropDownControllers2 = List.generate(categoryProduct!['key0']['food'].length, (_) => FormFieldController<String>(null));

      for (int i = 0; i < categoryProduct!['key0']['food'].length; i++) {
        categoryNameList.add(categoryProduct!['key0']['food'][i]['NameCategory']);
      }

      dropDownValues = List.filled(categoryProduct!['key0']['food'].length, null);
      dropDownValues2 = List.filled(categoryProduct!['key0']['food'].length, null);

      // Replace the URL with the actual URL of your JSON data.
      print('fetchData');
      var response = await DefaultAssetBundle.of(context).loadString('assets/thai_province_data.json.txt');
      print('-------');
      print(response);
      var result = json.decode(response);
      print('-------');
      print(result);
      provinces = result;
      print(provinces);
      provinces?.sort((a, b) {
        String nameA = a['name_th'];
        String nameB = b['name_th'];

        return nameA.compareTo(nameB);
      });
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
    _mapController.isCompleted;

    super.dispose();
  }

  trySummit(bool checkButtonSuccess) async {
    try {
      print('dsfsdfdsfdsfds');
      print(_model.radioButtonValueController ?? '');
      print('dsfsdfdsfdsfds');
      print(_model.textController1.text);
      print(_model.textController2.text);
      print(_model.textController3.text);
      print(_model.textController4.text);

      print(_model.textController5.text);
      print(_model.textController6.text);
      print(_model.textController7.text);
      print(_model.textController8.text);
      print(_model.textController9.text);
      print(_model.textController10.text);
      print(_model.textController11.text);

      for (int i = 0; i < total; i++) print(dropDownControllers[i].value);

      print(_model.textController12.text);
      print(_model.textController13.text);
      print(_model.textController14.text);

      for (int i = 0; i < total2; i++) print(dropDownControllers2[i].value);

      print(resultList);

      print(_model.dropDownValueController6!.value);

      print(_model.dropDownValue7);

      print(_model.dropDownValue8);

      print(_model.dropDownValue9);
      print(_model.dropDownValue10);

      print(_model.textController19.text);

      print(_model.textController20.text);

      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus();

      if (isValid) {
        _formKey.currentState!.save();
      }
      print('111');
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      // print(_sign.currentState);

      Uuid uuid = Uuid();

      String docID = uuid.v4();
      String signatureUrl = '';

      // @required this.finalFileResultStringPDPA,
      //======================== PDPA =========================================
      String signatureUrlPDPA = '';
      if (widget.base64ImgSignPDPA == '') {
      } else {
        signatureUrlPDPA = await saveSignatureToFirestorePDPA(widget.base64ImgSignPDPA!, docID);
      }
      //======================= ไฟล์เอกสาร PDPA =======================================
      print('ไฟล​์เอกสาร PDPA');
      List<String?>? fileUrlPDPA = [];

      for (int i = 0; i < widget.finalFileResultStringPDPA!.length; i++) {
        String fileName2 =
            '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}${widget.finalFileResultStringPDPA![i]}.pdf';
        if (widget.finalFileResultStringPDPA![i].isEmpty) {
          // listUrl.add(imageUrl[i]);
        } else {
          ref5 = FirebaseStorage.instance
              .ref()
              .child('files')
              .child('Users')
              .child(userController.userData!['UserID'])
              .child('Customer')
              .child('PDPA')
              .child(docID)
              .child(DateTime.now().month.toString())
              .child('${DateTime.now().day}/$fileName2');

          await ref5!.putFile(File(widget.finalFileResultStringPDPA![i])).whenComplete(
            () async {
              await ref5!.getDownloadURL().then(
                (fileUrlValue) {
                  fileUrlPDPA.add(fileUrlValue);
                },
              );
            },
          );
        }
      }
      //=======================================================================
      if (signConfirm == false) {
      } else {
        // final sign = _sign.currentState;
        // //retrieve image data, do whatever you want with it (send to server, save locally...)
        // final imageSign = await sign!.getData();
        // print('sing2');
        // var data = await imageSign.toByteData(format: ui.ImageByteFormat.png);
        // print('1');

        // print('1.1');
        // final encoded = base64.encode(data!.buffer.asUint8List());
        // print('1.2');
        // // setState(() {
        // //   _img = data;
        // // });
        // debugPrint("onPressed " + encoded);
        // print('2');
        print('sign');
        signatureUrl = await saveSignatureToFirestore(base64ImgSign, docID);
        print(signatureUrl);
      }

      List<String> listUrl = [];

      print('rrrrrrr');

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

      print('ttttttt');
      List<String> listUrl2 = [];

      for (int i = 0; i < image2!.length; i++) {
        String fileName2 =
            '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg';
        if (image2![i].path.isEmpty) {
          // listUrl.add(imageUrl[i]);
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
      print('yyyyyy');

      //======================= รูปเอกสาร =======================================
      print('รูปเอกสาร');
      List<List<String>> listUrlList2 = List.generate(5, (_) => []);

      for (int i = 0; i < imageList2!.length; i++) {
        for (int j = 0; j < imageList2![i]!.length; j++) {
          String fileName2 =
              '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.jpg';
          if (imageList2![i]![j].path.isEmpty) {
            // listUrl.add(imageUrl[i]);
          } else {
            ref3 = FirebaseStorage.instance
                .ref()
                .child('images')
                .child('Users')
                .child(userController.userData!['UserID'])
                .child('Customer')
                .child(docID)
                .child(DateTime.now().month.toString())
                .child('${DateTime.now().day}/$fileName2');

            await ref3!.putFile(imageList2![i]![j]).whenComplete(
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
      print('รูปเอกสาร');
      //========================================================================
      //======================= ไฟล์เอกสาร =======================================
      print('ไฟล​์เอกสาร');
      List<List<String>> fileUrl = List.generate(5, (_) => []);

      for (int i = 0; i < finalFileResultString!.length; i++) {
        for (int j = 0; j < finalFileResultString![i]!.length; j++) {
          String fileName2 =
              '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}$finalFileResultString.pdf';
          if (finalFileResultString![i]![j].isEmpty) {
            // listUrl.add(imageUrl[i]);
          } else {
            ref4 = FirebaseStorage.instance
                .ref()
                .child('files')
                .child('Users')
                .child(userController.userData!['UserID'])
                .child('Customer')
                .child(docID)
                .child(DateTime.now().month.toString())
                .child('${DateTime.now().day}/$fileName2');

            await ref4!.putFile(File(finalFileResultString![i]![j])).whenComplete(
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
      print('ไฟล์เอกสาร');
      //========================================================================

      // GoogleMapController controller = await _mapController.future;
      // // if (controller != null) {
      // controller.dispose();

      // GoogleMapController controller2 = await _mapController2.future;
      // // if (controller != null) {
      // controller2.dispose();
      // controller.dispose();
      // }
      print('pppp');
      print(_model.textController1Company.text);

      for (int i = 0; i < sendAndBillList!.length; i++) {
        resultListSendAndBill[i]['ชื่อออกบิล'] = sendAndBillList![i].text;
      }
      print('ffffff');

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

      print('zzzzz');
      await FirebaseFirestore.instance.collection('Customer').doc(docID).set({
        'CustomerID': docID,
        'PhoneID': _model.textController6.text,
        'CustomerDateCreate': DateTime.now(),
        'CustomerDateUpdate': DateTime.now(),
        'ประเภทลูกค้า': widget.type == 'company' ? 'Company' : 'Personal',
        'คำนำหน้า': _model.radioButtonValueController == null ? '' : _model.radioButtonValueController!.value,
        'vat': _model.radioButtonValueControllerVat == null ? '' : _model.radioButtonValueControllerVat!.value,

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
        'CategoryProductNow': productTypeFinal,
        'ระยะเวลาการดำเนินการ': _model.textController12.text,
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
        'ระยะเวลาชำระหนี้': _model.dropDownValue10 ?? '',
        'วงเงินเครดิต': _model.textController19.text,
        'ส่วนลดบิล': _model.textController20.text,
        'ประเภทชำระ': _model.dropDownValue11 ?? '',
        'เงื่อนไขชำระ': _model.dropDownValue12 ?? '',
        'บัญชีธนาคารของบริษัท': _model.dropDownValue13 ?? '',
        'แผนก': _model.dropDownValue14 ?? '',
        'รหัสบัญชี': _model.dropDownValue15 ?? '',
        'รหัสพนักงานขาย': userData!['EmployeeID'],
        'ชื่อพนักงานขาย': userData!['Name'] + ' ' + userData!['Surname'],
        'รหัสกลุ่มลูกค้า': _model.dropDownValue18 ?? '',
        'รหัสกลุ่มลูกค้า2': _model.dropDownValue182 ?? '',
        'รหัสกลุ่มลูกค้า3': _model.dropDownValue183 ?? '',
        'รหัสกลุ่มลูกค้า4': _model.dropDownValue184 ?? '',
        'รหัสกลุ่มลูกค้า5': _model.dropDownValue185 ?? '',
        'รหัสบัญชี2': _model.dropDownValue19 ?? '',
        'รูปร้านค้า': listUrl,
        // 'รูปเอกสาร2': listUrl2,
        'รูปเอกสาร': listOfMaps,
        'ไฟล์เอกสาร': listFileOfMaps,
        'ลายเซ็น': signatureUrl,
        'บันทึกพร้อมตรวจ': checkButtonSuccess,
        'สถานะ': false,
        'รอการอนุมัติ': checkButtonSuccess == true ? false : true,
        'ขั้นตอนอนุมัติ': [false, false, false, false, false, false],
        'ชื่อบริษัท': _model.textController1Company.text,
        'วันจัดตั้ง': _model.textController2Company.text,
        'เดือนจัดตั้ง': _model.textController3Company.text,
        'ปีจัดตั้ง': _model.textController4Company.text,
        'เลขประจำตัวผู้เสียภาษี': _model.textController41Company.text,
        'ทุนจดทะเบียน': _model.textController5Company.text,
        'UserId': userController.userData!['UserID'],
        'PDPA': {
          'สถานะ': true,
          'คำถาม': widget.quizPDPA,
          'ไฟล์': fileUrlPDPA,
          'ลายเซ็น': signatureUrlPDPA,
        },
      }).then((value) {
        print('3');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      });
    } catch (e) {
      print(e);
    } finally {
      // resultList.clear();
    }
  }

  Future<String> saveSignatureToFirestorePDPA(String base64String, String docID) async {
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

  Future<String> saveSignatureToFirestore(String base64String, String docID) async {
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
    print('This is Form General User ');
    print('==============================');
    print('============= ---------- ============');
    print(widget.type);
    print(widget.base64ImgSignPDPA);
    print(widget.finalFileResultStringPDPA);
    print(widget.quizPDPA);
    print('============= ---------- ============');
    userData = userController.userData;
    userData = userController.userData;
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
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //========================  ocr =====================================
                          widget.type == 'company'
                              ? SizedBox(
                                  height: 5,
                                )
                              : InkWell(
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
                                          'กรุณาเชื่อมต่ออินเตอร์เน็ต สามารถเปิดกล้องถ่ายหน้าบัตรและอ่าน ORC ได้จากที่นี่',
                                          style: FlutterFlowTheme.of(context).bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          //======================= checkbox คำนำหน้า ======================================
                          widget.type == 'company'
                              ? SizedBox()
                              : Padding(
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
                                        controller: _model.radioButtonValueController ??= FormFieldController<String>(null),
                                        optionHeight: 32.0,
                                        textStyle: FlutterFlowTheme.of(context).labelMedium,
                                        selectedTextStyle: FlutterFlowTheme.of(context).bodyMedium,
                                        buttonPosition: RadioButtonPosition.left,
                                        direction: Axis.horizontal,
                                        radioButtonColor: FlutterFlowTheme.of(context).primary,
                                        inactiveRadioButtonColor: FlutterFlowTheme.of(context).secondaryText,
                                        toggleable: false,
                                        horizontalAlignment: WrapAlignment.start,
                                        verticalAlignment: WrapCrossAlignment.start,
                                      ),
                                    ],
                                  ),
                                ),
                          //=========================== ชื่อ นามสกุล /ชื่อบริษัn==================================
                          widget.type == 'company'
                              ? Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                  child: TextFormField(
                                    controller: _model.textController1Company,
                                    focusNode: _model.textFieldFocusNode1Company,
                                    autofocus: true,
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
                                )
                              : Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                  child: TextFormField(
                                    controller: _model.textController1,
                                    focusNode: _model.textFieldFocusNode1,
                                    autofocus: true,
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
                                ),

                          //======================= checkbox vat ======================================
                          widget.type == 'company'
                              ? Padding(
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
                                        controller: _model.radioButtonValueControllerVat ??= FormFieldController<String>(null),
                                        optionHeight: 32.0,
                                        textStyle: FlutterFlowTheme.of(context).labelMedium,
                                        selectedTextStyle: FlutterFlowTheme.of(context).bodyMedium,
                                        buttonPosition: RadioButtonPosition.left,
                                        direction: Axis.horizontal,
                                        radioButtonColor: FlutterFlowTheme.of(context).primary,
                                        inactiveRadioButtonColor: FlutterFlowTheme.of(context).secondaryText,
                                        toggleable: false,
                                        horizontalAlignment: WrapAlignment.start,
                                        verticalAlignment: WrapCrossAlignment.start,
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(),

                          //======================= วันเดือนปีเกิด/วันเดือนปีที่จัดจัดตั้ง ======================================
                          widget.type == 'company'
                              ? Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
                                  child: StatefulBuilder(builder: (context, setState) {
                                    return GestureDetector(
                                      onTap: () async {
                                        print('Gesture');
                                        await selectDateCompany(context);
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
                                                  await selectDateCompany(context);
                                                },
                                                child: Container(
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    controller: _model.textController2Company,
                                                    focusNode: _model.textFieldFocusNode2Company,
                                                    autofocus: true,
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
                                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                              child: GestureDetector(
                                                behavior: HitTestBehavior.opaque,
                                                onTap: () async {
                                                  print('Gesture');
                                                  await selectDateCompany(context);
                                                },
                                                child: Container(
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    controller: _model.textController3Company,
                                                    focusNode: _model.textFieldFocusNode3Company,
                                                    autofocus: true,
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
                                                    validator: _model.textController3Validator.asValidator(context),
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
                                                await selectDateCompany(context);
                                              },
                                              child: Container(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    controller: _model.textController4Company,
                                                    focusNode: _model.textFieldFocusNode4Company,
                                                    autofocus: true,
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
                                )
                              : Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
                                  child: StatefulBuilder(builder: (context, setState) {
                                    return GestureDetector(
                                      onTap: () async {
                                        print('Gesture');
                                        // await selectDate(context);
                                        bottomPicker(context);
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
                                              child: Container(
                                                child: TextFormField(
                                                  readOnly: true,
                                                  controller: _model.textController2,
                                                  focusNode: _model.textFieldFocusNode2,
                                                  autofocus: true,
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
                                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                  ],
                                                  validator: (value) {
                                                    if (value!.isNotEmpty) {
                                                      if (value.length > 2) {
                                                        return 'เลข 1 - 2 หลักค่ะ';
                                                      }
                                                    }

                                                    return null;
                                                  },
                                                  onTap: () async {
                                                    bottomPicker(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                              child: Container(
                                                child: TextFormField(
                                                  readOnly: true,
                                                  controller: _model.textController3,
                                                  focusNode: _model.textFieldFocusNode3,
                                                  autofocus: true,
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
                                                  validator: _model.textController3Validator.asValidator(context),
                                                  onTap: () async {
                                                    bottomPicker(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                              child: Container(
                                                child: TextFormField(
                                                  readOnly: true,
                                                  controller: _model.textController4,
                                                  focusNode: _model.textFieldFocusNode4,
                                                  autofocus: true,
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
                                                  ],
                                                  validator: (value) {
                                                    if (value!.isNotEmpty) {
                                                      if (value.length != 4) {
                                                        return 'ตัวเลข 4 หลักค่ะ';
                                                      }
                                                    }

                                                    return null;
                                                  },
                                                  onTap: () async {
                                                    bottomPicker(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),

                          //======================= เลขประจำตัวผู้เสียภาษี ======================================
                          widget.type == 'company'
                              ? StatefulBuilder(builder: (context, setState) {
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        checkID == 'red'
                                            ? Text('!! หมายเลขนี้มีสมาชิกในระบบแล้ว',
                                                style: FlutterFlowTheme.of(context).redSmall //redSmall orangeSmall

                                                )
                                            : checkID == 'orange'
                                                ? Text('ลูกค้าที่เคย Reject', style: FlutterFlowTheme.of(context).orangeSmall //redSmall orangeSmall

                                                    )
                                                : Text('สามารถเปิดบัญชีได้', style: FlutterFlowTheme.of(context).greenSmall //redSmall orangeSmall

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
                                                  .collection('Customer')
                                                  .where('เลขประจำตัวผู้เสียภาษี', isEqualTo: _model.textController5.text)
                                                  .get();

                                              if (querySnapshot.docs.isNotEmpty) {
                                                querySnapshot.docs.forEach((doc) {
                                                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
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
                                            }
                                          },
                                          controller: _model.textController41Company,
                                          focusNode: _model.textFieldFocusNode41Company,
                                          autofocus: true,
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
                                            FilteringTextInputFormatter.digitsOnly,
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
                                })
                              : SizedBox(),
                          //======================= เลขที่บัตรประชาชน / ทุนจดทะเบียน ======================================
                          widget.type == 'company'
                              ? Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                                  child: TextFormField(
                                    controller: _model.textController5Company,
                                    focusNode: _model.textFieldFocusNode5Company,
                                    autofocus: true,
                                    obscureText: false,

                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                      labelText: 'ทุนจดทะเบียน',
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
                                )
                              : StatefulBuilder(builder: (context, setState) {
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        checkID == 'red'
                                            ? Text('!! หมายเลขนี้มีสมาชิกในระบบแล้ว',
                                                style: FlutterFlowTheme.of(context).redSmall //redSmall orangeSmall

                                                )
                                            : checkID == 'orange'
                                                ? Text('ลูกค้าที่เคย Reject', style: FlutterFlowTheme.of(context).orangeSmall //redSmall orangeSmall

                                                    )
                                                : Text('สามารถเปิดบัญชีได้', style: FlutterFlowTheme.of(context).greenSmall //redSmall orangeSmall

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
                                                  .collection('Customer')
                                                  .where('เลขบัตรประชาชน', isEqualTo: _model.textController5.text)
                                                  .get();

                                              if (querySnapshot.docs.isNotEmpty) {
                                                querySnapshot.docs.forEach((doc) {
                                                  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
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
                                            }
                                          },
                                          controller: _model.textController5,
                                          focusNode: _model.textFieldFocusNode5,
                                          autofocus: true,
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
                                            FilteringTextInputFormatter.digitsOnly,
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
                                }),
                          //===================== เบอร์โทรศัพท์ ========================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                            child: TextFormField(
                              controller: _model.textController6,
                              focusNode: _model.textFieldFocusNode6,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
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
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              textAlign: TextAlign.start,
                              // validator: _model.textController6Validator
                              //     .asValidator(context),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
                            child: StatefulBuilder(builder: (context, setState) {
                              return GestureDetector(
                                onTap: () async {
                                  print('Gesture');
                                  await selectDateToSend(context);
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
                                        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: _model.textController7,
                                          focusNode: _model.textFieldFocusNode7,
                                          autofocus: true,
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
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
                                        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: _model.textController8,
                                          focusNode: _model.textFieldFocusNode8,
                                          autofocus: true,
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
                                          validator: _model.textController8Validator.asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                        child: TextFormField(
                                          readOnly: true,

                                          controller: _model.textController9,
                                          focusNode: _model.textFieldFocusNode9,
                                          autofocus: true,
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
                              );
                            }),
                          ),
                          //=========================== ชื่อร้าน/แผงในตลาด ==================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                            child: TextFormField(
                              controller: _model.textController10,
                              focusNode: _model.textFieldFocusNode10,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                labelText: widget.type == 'company' ? 'ชื่อร้าน' : 'ชื่อร้าน/แผงในตลาด',
                                hintText: widget.type == 'company' ? 'ชื่อร้าน' : 'ชื่อร้าน/แผงในตลาด',
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
                          ), //=============================================================
                          //=========================== เป้าการขาย ==================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                            child: TextFormField(
                              controller: _model.textController11,
                              focusNode: _model.textFieldFocusNode11,
                              autofocus: true,
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
                          ),
                          //============================= dropdown ประเภทสินค้าที่ขายในปัจจุบัน ================================
                          StatefulBuilder(
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
                                                                textFieldFocusProductType!.removeLast();
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
                                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                                              child: TextFormField(
                                                controller: productType![index],
                                                focusNode: textFieldFocusProductType![index],
                                                autofocus: true,
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  labelText: 'ประเภทสินค้า',
                                                  isDense: true,
                                                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                                  hintText: 'ประเภทสินค้า',
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
                                              ),
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
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'ระยะเวลาการดำเนินการ',
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                    child: TextFormField(
                                      controller: _model.textController12,
                                      focusNode: _model.textFieldFocusNode12,
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                        labelText: 'ระยะเวลาการดำเนินการ',
                                        hintText: 'ระยะเวลาการดำเนินการ',
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
                                      keyboardType: TextInputType.text,
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
                              ],
                            ),
                          ),
                          //======================== dropdown กลุ่มสินค้าท่สั่งซืื้อ =====================================
                          StatefulBuilder(
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
                                                              onTap: () => setState(() => total2 = total2 - 1),
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
                                              margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
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
                                          onTap: () => setState(() => total2 = total2 + 1),
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
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'ที่อยู่ในการจัดส่ง (ระบุได้มากกว่า 1 สถานที่) โดยเลือก จังหวัด ,อำเภอ , ตำบล , รหัสไปรษณีย์',
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              ],
                            ),
                          ), //========================= ที่อยู่ในการจัดส่ง แบบหลายอัน ====================================
                          //=========================== ลิสต์ที่อยู่ในการจัดส่ง ==================================
                          StatefulBuilder(builder: (context, setState) {
                            // print(total3);
                            // print(resultList.length);

                            if (resultList.length == total3) {
                            } else {
                              for (int i = resultList.length; i < total3; i++) {
                                // print(total3);
                                // print(i);
                                resultList.add({
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
                                  'โทรศัพท์': '', //new
                                });
                                selected.add({
                                  'province_id': null,
                                  'amphure_id': null,
                                  'tambon_id': null,
                                });
                                amphures!.add([]);
                                tambons!.add([]);
                                // print(resultList.length);
                                textFieldFocusHouseNumber!.add(FocusNode());
                                textFieldFocusVillageName!.add(FocusNode());
                                textFieldFocusPostalCode!.add(FocusNode());
                                textFieldFocusLatitude!.add(FocusNode());
                                textFieldFocusLongitude!.add(FocusNode());

                                textFieldFocusSaka!.add(FocusNode());
                                textFieldFocusRoad!.add(FocusNode());
                                textFieldFocusNameSaka!.add(FocusNode());
                                textFieldFocusPhone!.add(FocusNode());
                                textFieldFocusType!.add(FocusNode());
                                textFieldFocusNameContract!.add(FocusNode());

                                dropDownValueControllerProvince.add(FormFieldController<String>(''));
                                dropDownValueControllerDistrict.add(FormFieldController<String>(''));
                                dropDownValueControllerSubDistrict.add(FormFieldController<String>(''));
                                // print(textFieldFocusHouseNumber!.length);
                                latList!.add(TextEditingController());
                                lotList!.add(TextEditingController());

                                dropDownControllersimageAddress.add(FormFieldController<String>(''));
                              }
                            }

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
                                              ' ที่อยู่ในการจัดส่ง ลำดับที่ ${index + 1}',
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
                                                            textFieldFocusVillageName!.removeLast();
                                                            textFieldFocusPostalCode!.removeLast();
                                                            textFieldFocusLatitude!.removeLast();
                                                            textFieldFocusLongitude!.removeLast();
                                                            textFieldFocusSaka!.removeLast();
                                                            textFieldFocusRoad!.removeLast();
                                                            textFieldFocusNameSaka!.removeLast();
                                                            textFieldFocusPhone!.removeLast();
                                                            textFieldFocusType!.removeLast();
                                                            textFieldFocusNameContract!.removeLast();
                                                            dropDownValueControllerProvince.removeLast();
                                                            dropDownValueControllerDistrict.removeLast();
                                                            dropDownValueControllerSubDistrict.removeLast();
                                                            latList!.removeLast();
                                                            lotList!.removeLast();

                                                            dropDownControllersimageAddress.removeLast();
                                                            addressAllForDropdown.clear();

                                                            setState(() {
                                                              // for (int i = 0;
                                                              //     i <
                                                              //         resultList
                                                              //             .length;
                                                              //     i++) {
                                                              //   // รวมข้อมูลจากทุก field ในแต่ละ map เป็น string เดียว
                                                              //   String
                                                              //       combinedFields =
                                                              //       resultList[
                                                              //               i]
                                                              //           .values
                                                              //           .join(
                                                              //               ' ');

                                                              //   // นำ string ไปแทนที่ใน list options
                                                              //   addressAllForDropdown
                                                              //       .add(
                                                              //           '$combinedFields');
                                                              // }
                                                              //====================================================================
                                                              List<Map<String, dynamic>> addressThai = [];

                                                              // List<String?>? textList = [];
                                                              for (int i = 0; i < resultList.length; i++) {
                                                                // resultList.add(false);

                                                                List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

                                                                List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
                                                                List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
                                                                String? provincesName;
                                                                String? amphorName;
                                                                String? tambonName;

                                                                //====================================================================
                                                                if (resultList[i]['Province'] == '' || resultList[i]['Province'] == null) {
                                                                  provincesName = '';
                                                                } else {
                                                                  Map<String, dynamic> resultProvince = mapProvincesList.firstWhere(
                                                                      (element) => element['id'] == resultList[i]['Province'],
                                                                      orElse: () => {});

                                                                  provincesName = resultProvince['name_th'] ?? '';
                                                                }
                                                                //====================================================================
                                                                if (resultList[i]['District'] == '' || resultList[i]['District'] == null) {
                                                                  amphorName = '';
                                                                } else {
                                                                  Map<String, dynamic> resultAmphure = mapList.firstWhere(
                                                                      (element) => element['id'] == resultList[i]['District'],
                                                                      orElse: () => {});

                                                                  amphorName = resultAmphure['name_th'] ?? '';
                                                                }

                                                                //====================================================================
                                                                if (resultList[i]['SubDistrict'] == '' || resultList[i]['SubDistrict'] == null) {
                                                                  tambonName = '';
                                                                } else {
                                                                  Map<String, dynamic> resultTambon = tambonList.firstWhere(
                                                                      (element) => element['id'] == resultList[i]['SubDistrict'],
                                                                      orElse: () => {});
                                                                  tambonName = resultTambon['name_th'] ?? '';
                                                                }
                                                                //====================================================================
                                                                addressThai.add({
                                                                  'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
                                                                  'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
                                                                  'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
                                                                });

                                                                print(addressThai);

                                                                String texttt =
                                                                    '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                                // textList[i]!.add(text.trimLeft());
                                                                addressAllForDropdown.add(texttt.trimLeft());
                                                              }
                                                            });

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
                                        //======================= รหัสสาขา ================================
                                        TextFormField(
                                          // controller: _model.textController15,
                                          onChanged: (value) {
                                            resultList[index]['รหัสสาขา'] = value;
                                            print(index);
                                            print(resultList[index]['รหัสสาขา']);

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
                                              //====================================================================
                                              List<Map<String, dynamic>> addressThai = [];

                                              // List<String?>? textList = [];
                                              for (int i = 0; i < resultList.length; i++) {
                                                // resultList.add(false);

                                                List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

                                                List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
                                                List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
                                                String? provincesName;
                                                String? amphorName;
                                                String? tambonName;

                                                //====================================================================
                                                if (resultList[i]['Province'] == '' || resultList[i]['Province'] == null) {
                                                  provincesName = '';
                                                } else {
                                                  Map<String, dynamic> resultProvince = mapProvincesList
                                                      .firstWhere((element) => element['id'] == resultList[i]['Province'], orElse: () => {});

                                                  provincesName = resultProvince['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                if (resultList[i]['District'] == '' || resultList[i]['District'] == null) {
                                                  amphorName = '';
                                                } else {
                                                  Map<String, dynamic> resultAmphure =
                                                      mapList.firstWhere((element) => element['id'] == resultList[i]['District'], orElse: () => {});

                                                  amphorName = resultAmphure['name_th'] ?? '';
                                                }

                                                //====================================================================
                                                if (resultList[i]['SubDistrict'] == '' || resultList[i]['SubDistrict'] == null) {
                                                  tambonName = '';
                                                } else {
                                                  Map<String, dynamic> resultTambon = tambonList
                                                      .firstWhere((element) => element['id'] == resultList[i]['SubDistrict'], orElse: () => {});
                                                  tambonName = resultTambon['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                addressThai.add({
                                                  'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
                                                  'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
                                                  'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
                                                });

                                                print(addressThai);

                                                String texttt =
                                                    '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                // textList[i]!.add(text.trimLeft());
                                                addressAllForDropdown.add(texttt.trimLeft());
                                              }
                                            });
                                            print(addressAllForDropdown);
                                            toSetState();
                                          },
                                          focusNode: textFieldFocusSaka![index],
                                          autofocus: true,
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
                                          validator: _model.textController15Validator.asValidator(context),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        //======================= ชื่อสาขา ================================
                                        TextFormField(
                                          // controller: _model.textController15,
                                          onChanged: (value) {
                                            resultList[index]['ชื่อสาขา'] = value;
                                            print(index);
                                            print(resultList[index]['ชื่อสาขา']);

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
                                              //====================================================================
                                              List<Map<String, dynamic>> addressThai = [];

                                              // List<String?>? textList = [];
                                              for (int i = 0; i < resultList.length; i++) {
                                                // resultList.add(false);

                                                List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

                                                List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
                                                List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
                                                String? provincesName;
                                                String? amphorName;
                                                String? tambonName;

                                                //====================================================================
                                                if (resultList[i]['Province'] == '' || resultList[i]['Province'] == null) {
                                                  provincesName = '';
                                                } else {
                                                  Map<String, dynamic> resultProvince = mapProvincesList
                                                      .firstWhere((element) => element['id'] == resultList[i]['Province'], orElse: () => {});

                                                  provincesName = resultProvince['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                if (resultList[i]['District'] == '' || resultList[i]['District'] == null) {
                                                  amphorName = '';
                                                } else {
                                                  Map<String, dynamic> resultAmphure =
                                                      mapList.firstWhere((element) => element['id'] == resultList[i]['District'], orElse: () => {});

                                                  amphorName = resultAmphure['name_th'] ?? '';
                                                }

                                                //====================================================================
                                                if (resultList[i]['SubDistrict'] == '' || resultList[i]['SubDistrict'] == null) {
                                                  tambonName = '';
                                                } else {
                                                  Map<String, dynamic> resultTambon = tambonList
                                                      .firstWhere((element) => element['id'] == resultList[i]['SubDistrict'], orElse: () => {});
                                                  tambonName = resultTambon['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                addressThai.add({
                                                  'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
                                                  'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
                                                  'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
                                                });

                                                print(addressThai);

                                                String texttt =
                                                    '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                // textList[i]!.add(text.trimLeft());
                                                addressAllForDropdown.add(texttt.trimLeft());
                                              }
                                            });
                                            print(addressAllForDropdown);
                                            toSetState();
                                          },
                                          focusNode: textFieldFocusNameSaka![index],
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            labelStyle: FlutterFlowTheme.of(context).labelMedium,
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
                                          validator: _model.textController15Validator.asValidator(context),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        //======================= บ้านเลขที่ ================================
                                        TextFormField(
                                          // controller: _model.textController15,
                                          onChanged: (value) {
                                            resultList[index]['HouseNumber'] = value;
                                            print(index);
                                            print(resultList[index]['HouseNumber']);

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
                                              //====================================================================
                                              List<Map<String, dynamic>> addressThai = [];

                                              // List<String?>? textList = [];
                                              for (int i = 0; i < resultList.length; i++) {
                                                // resultList.add(false);

                                                List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

                                                List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
                                                List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
                                                String? provincesName;
                                                String? amphorName;
                                                String? tambonName;

                                                //====================================================================
                                                if (resultList[i]['Province'] == '' || resultList[i]['Province'] == null) {
                                                  provincesName = '';
                                                } else {
                                                  Map<String, dynamic> resultProvince = mapProvincesList
                                                      .firstWhere((element) => element['id'] == resultList[i]['Province'], orElse: () => {});

                                                  provincesName = resultProvince['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                if (resultList[i]['District'] == '' || resultList[i]['District'] == null) {
                                                  amphorName = '';
                                                } else {
                                                  Map<String, dynamic> resultAmphure =
                                                      mapList.firstWhere((element) => element['id'] == resultList[i]['District'], orElse: () => {});

                                                  amphorName = resultAmphure['name_th'] ?? '';
                                                }

                                                //====================================================================
                                                if (resultList[i]['SubDistrict'] == '' || resultList[i]['SubDistrict'] == null) {
                                                  tambonName = '';
                                                } else {
                                                  Map<String, dynamic> resultTambon = tambonList
                                                      .firstWhere((element) => element['id'] == resultList[i]['SubDistrict'], orElse: () => {});
                                                  tambonName = resultTambon['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                addressThai.add({
                                                  'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
                                                  'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
                                                  'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
                                                });

                                                print(addressThai);

                                                String texttt =
                                                    '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                // textList[i]!.add(text.trimLeft());
                                                addressAllForDropdown.add(texttt.trimLeft());
                                              }
                                            });
                                            print(addressAllForDropdown);
                                            toSetState();
                                          },
                                          focusNode: textFieldFocusHouseNumber![index],
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
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
                                          validator: _model.textController15Validator.asValidator(context),
                                        ),

                                        //========================== ชื่อหมู่บ้าน=============================================
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                                          child: TextFormField(
                                            // controller: _model.textController16,
                                            onChanged: (value) {
                                              resultList[index]['VillageName'] = value;
                                              print(index);
                                              print(resultList[index]['VillageName']);
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
                                                //====================================================================
                                                List<Map<String, dynamic>> addressThai = [];

                                                // List<String?>? textList = [];
                                                for (int i = 0; i < resultList.length; i++) {
                                                  // resultList.add(false);

                                                  List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

                                                  List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
                                                  List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
                                                  String? provincesName;
                                                  String? amphorName;
                                                  String? tambonName;

                                                  //====================================================================
                                                  if (resultList[i]['Province'] == '' || resultList[i]['Province'] == null) {
                                                    provincesName = '';
                                                  } else {
                                                    Map<String, dynamic> resultProvince = mapProvincesList
                                                        .firstWhere((element) => element['id'] == resultList[i]['Province'], orElse: () => {});

                                                    provincesName = resultProvince['name_th'] ?? '';
                                                  }
                                                  //====================================================================
                                                  if (resultList[i]['District'] == '' || resultList[i]['District'] == null) {
                                                    amphorName = '';
                                                  } else {
                                                    Map<String, dynamic> resultAmphure =
                                                        mapList.firstWhere((element) => element['id'] == resultList[i]['District'], orElse: () => {});

                                                    amphorName = resultAmphure['name_th'] ?? '';
                                                  }

                                                  //====================================================================
                                                  if (resultList[i]['SubDistrict'] == '' || resultList[i]['SubDistrict'] == null) {
                                                    tambonName = '';
                                                  } else {
                                                    Map<String, dynamic> resultTambon = tambonList
                                                        .firstWhere((element) => element['id'] == resultList[i]['SubDistrict'], orElse: () => {});
                                                    tambonName = resultTambon['name_th'] ?? '';
                                                  }
                                                  //====================================================================
                                                  addressThai.add({
                                                    'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
                                                    'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
                                                    'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
                                                  });

                                                  print(addressThai);

                                                  String texttt =
                                                      '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                  // textList[i]!.add(text.trimLeft());
                                                  addressAllForDropdown.add(texttt.trimLeft());
                                                }
                                              });

                                              toSetState();
                                            },
                                            focusNode: textFieldFocusVillageName![index],
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
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
                                            validator: _model.textController16Validator.asValidator(context),
                                          ),
                                        ),

                                        //======================= ถนน ================================
                                        TextFormField(
                                          // controller: _model.textController15,
                                          onChanged: (value) {
                                            resultList[index]['Road'] = value;
                                            print(index);
                                            print(resultList[index]['Road']);

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
                                              //====================================================================
                                              List<Map<String, dynamic>> addressThai = [];

                                              // List<String?>? textList = [];
                                              for (int i = 0; i < resultList.length; i++) {
                                                // resultList.add(false);

                                                List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

                                                List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
                                                List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
                                                String? provincesName;
                                                String? amphorName;
                                                String? tambonName;

                                                //====================================================================
                                                if (resultList[i]['Province'] == '' || resultList[i]['Province'] == null) {
                                                  provincesName = '';
                                                } else {
                                                  Map<String, dynamic> resultProvince = mapProvincesList
                                                      .firstWhere((element) => element['id'] == resultList[i]['Province'], orElse: () => {});

                                                  provincesName = resultProvince['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                if (resultList[i]['District'] == '' || resultList[i]['District'] == null) {
                                                  amphorName = '';
                                                } else {
                                                  Map<String, dynamic> resultAmphure =
                                                      mapList.firstWhere((element) => element['id'] == resultList[i]['District'], orElse: () => {});

                                                  amphorName = resultAmphure['name_th'] ?? '';
                                                }

                                                //====================================================================
                                                if (resultList[i]['SubDistrict'] == '' || resultList[i]['SubDistrict'] == null) {
                                                  tambonName = '';
                                                } else {
                                                  Map<String, dynamic> resultTambon = tambonList
                                                      .firstWhere((element) => element['id'] == resultList[i]['SubDistrict'], orElse: () => {});
                                                  tambonName = resultTambon['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                addressThai.add({
                                                  'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
                                                  'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
                                                  'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
                                                });

                                                print(addressThai);

                                                String texttt =
                                                    '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                // textList[i]!.add(text.trimLeft());
                                                addressAllForDropdown.add(texttt.trimLeft());
                                              }
                                            });
                                            print(addressAllForDropdown);
                                            toSetState();
                                          },
                                          focusNode: textFieldFocusRoad![index],
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
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
                                          validator: _model.textController15Validator.asValidator(context),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        //=============================================================

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
                                        //======================== รหัสไปรษณีย์ ================================
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 5.0),
                                          child: TextFormField(
                                            // controller: _model.textController17,
                                            onChanged: (value) {
                                              resultList[index]['PostalCode'] = value;
                                              print(index);
                                              print(resultList[index]['PostalCode']);

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
                                                //====================================================================
                                                List<Map<String, dynamic>> addressThai = [];

                                                // List<String?>? textList = [];
                                                for (int i = 0; i < resultList.length; i++) {
                                                  // resultList.add(false);

                                                  List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

                                                  List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
                                                  List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
                                                  String? provincesName;
                                                  String? amphorName;
                                                  String? tambonName;

                                                  //====================================================================
                                                  if (resultList[i]['Province'] == '' || resultList[i]['Province'] == null) {
                                                    provincesName = '';
                                                  } else {
                                                    Map<String, dynamic> resultProvince = mapProvincesList
                                                        .firstWhere((element) => element['id'] == resultList[i]['Province'], orElse: () => {});

                                                    provincesName = resultProvince['name_th'] ?? '';
                                                  }
                                                  //====================================================================
                                                  if (resultList[i]['District'] == '' || resultList[i]['District'] == null) {
                                                    amphorName = '';
                                                  } else {
                                                    Map<String, dynamic> resultAmphure =
                                                        mapList.firstWhere((element) => element['id'] == resultList[i]['District'], orElse: () => {});

                                                    amphorName = resultAmphure['name_th'] ?? '';
                                                  }

                                                  //====================================================================
                                                  if (resultList[i]['SubDistrict'] == '' || resultList[i]['SubDistrict'] == null) {
                                                    tambonName = '';
                                                  } else {
                                                    Map<String, dynamic> resultTambon = tambonList
                                                        .firstWhere((element) => element['id'] == resultList[i]['SubDistrict'], orElse: () => {});
                                                    tambonName = resultTambon['name_th'] ?? '';
                                                  }
                                                  //====================================================================
                                                  addressThai.add({
                                                    'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
                                                    'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
                                                    'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
                                                  });

                                                  print(addressThai);

                                                  String texttt =
                                                      '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                  // textList[i]!.add(text.trimLeft());
                                                  addressAllForDropdown.add(texttt.trimLeft());
                                                }
                                              });
                                              toSetState();
                                            },
                                            focusNode: textFieldFocusPostalCode![index],
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
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

                                        //======================= ผู้ติดต่อ ================================
                                        TextFormField(
                                          // controller: _model.textController15,
                                          onChanged: (value) {
                                            resultList[index]['ผู้ติดต่อ'] = value;
                                            print(index);
                                            print(resultList[index]['ผู้ติดต่อ']);

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
                                              //====================================================================
                                              List<Map<String, dynamic>> addressThai = [];

                                              // List<String?>? textList = [];
                                              for (int i = 0; i < resultList.length; i++) {
                                                // resultList.add(false);

                                                List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

                                                List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
                                                List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
                                                String? provincesName;
                                                String? amphorName;
                                                String? tambonName;

                                                //====================================================================
                                                if (resultList[i]['Province'] == '' || resultList[i]['Province'] == null) {
                                                  provincesName = '';
                                                } else {
                                                  Map<String, dynamic> resultProvince = mapProvincesList
                                                      .firstWhere((element) => element['id'] == resultList[i]['Province'], orElse: () => {});

                                                  provincesName = resultProvince['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                if (resultList[i]['District'] == '' || resultList[i]['District'] == null) {
                                                  amphorName = '';
                                                } else {
                                                  Map<String, dynamic> resultAmphure =
                                                      mapList.firstWhere((element) => element['id'] == resultList[i]['District'], orElse: () => {});

                                                  amphorName = resultAmphure['name_th'] ?? '';
                                                }

                                                //====================================================================
                                                if (resultList[i]['SubDistrict'] == '' || resultList[i]['SubDistrict'] == null) {
                                                  tambonName = '';
                                                } else {
                                                  Map<String, dynamic> resultTambon = tambonList
                                                      .firstWhere((element) => element['id'] == resultList[i]['SubDistrict'], orElse: () => {});
                                                  tambonName = resultTambon['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                addressThai.add({
                                                  'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
                                                  'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
                                                  'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
                                                });

                                                print(addressThai);

                                                String texttt =
                                                    '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                // textList[i]!.add(text.trimLeft());
                                                addressAllForDropdown.add(texttt.trimLeft());
                                              }
                                            });
                                            print(addressAllForDropdown);
                                            toSetState();
                                          },
                                          focusNode: textFieldFocusNameContract![index],
                                          autofocus: true,
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
                                          validator: _model.textController15Validator.asValidator(context),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),

                                        //======================= ตำแหน่ง ================================
                                        TextFormField(
                                          // controller: _model.textController15,
                                          onChanged: (value) {
                                            resultList[index]['ตำแหน่ง'] = value;
                                            print(index);
                                            print(resultList[index]['ตำแหน่ง']);

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
                                              //====================================================================
                                              List<Map<String, dynamic>> addressThai = [];

                                              // List<String?>? textList = [];
                                              for (int i = 0; i < resultList.length; i++) {
                                                // resultList.add(false);

                                                List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

                                                List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
                                                List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
                                                String? provincesName;
                                                String? amphorName;
                                                String? tambonName;

                                                //====================================================================
                                                if (resultList[i]['Province'] == '' || resultList[i]['Province'] == null) {
                                                  provincesName = '';
                                                } else {
                                                  Map<String, dynamic> resultProvince = mapProvincesList
                                                      .firstWhere((element) => element['id'] == resultList[i]['Province'], orElse: () => {});

                                                  provincesName = resultProvince['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                if (resultList[i]['District'] == '' || resultList[i]['District'] == null) {
                                                  amphorName = '';
                                                } else {
                                                  Map<String, dynamic> resultAmphure =
                                                      mapList.firstWhere((element) => element['id'] == resultList[i]['District'], orElse: () => {});

                                                  amphorName = resultAmphure['name_th'] ?? '';
                                                }

                                                //====================================================================
                                                if (resultList[i]['SubDistrict'] == '' || resultList[i]['SubDistrict'] == null) {
                                                  tambonName = '';
                                                } else {
                                                  Map<String, dynamic> resultTambon = tambonList
                                                      .firstWhere((element) => element['id'] == resultList[i]['SubDistrict'], orElse: () => {});
                                                  tambonName = resultTambon['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                addressThai.add({
                                                  'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
                                                  'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
                                                  'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
                                                });

                                                print(addressThai);

                                                String texttt =
                                                    '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                // textList[i]!.add(text.trimLeft());
                                                addressAllForDropdown.add(texttt.trimLeft());
                                              }
                                            });
                                            print(addressAllForDropdown);
                                            toSetState();
                                          },
                                          focusNode: textFieldFocusType![index],
                                          autofocus: true,
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
                                          validator: _model.textController15Validator.asValidator(context),
                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),
                                        //======================= โทรศัพท์ ================================
                                        TextFormField(
                                          // controller: _model.textController15,
                                          onChanged: (value) {
                                            resultList[index]['โทรศัพท์'] = value;
                                            print(index);
                                            print(resultList[index]['โทรศัพท์']);

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
                                              //====================================================================
                                              List<Map<String, dynamic>> addressThai = [];

                                              // List<String?>? textList = [];
                                              for (int i = 0; i < resultList.length; i++) {
                                                // resultList.add(false);

                                                List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

                                                List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
                                                List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
                                                String? provincesName;
                                                String? amphorName;
                                                String? tambonName;

                                                //====================================================================
                                                if (resultList[i]['Province'] == '' || resultList[i]['Province'] == null) {
                                                  provincesName = '';
                                                } else {
                                                  Map<String, dynamic> resultProvince = mapProvincesList
                                                      .firstWhere((element) => element['id'] == resultList[i]['Province'], orElse: () => {});

                                                  provincesName = resultProvince['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                if (resultList[i]['District'] == '' || resultList[i]['District'] == null) {
                                                  amphorName = '';
                                                } else {
                                                  Map<String, dynamic> resultAmphure =
                                                      mapList.firstWhere((element) => element['id'] == resultList[i]['District'], orElse: () => {});

                                                  amphorName = resultAmphure['name_th'] ?? '';
                                                }

                                                //====================================================================
                                                if (resultList[i]['SubDistrict'] == '' || resultList[i]['SubDistrict'] == null) {
                                                  tambonName = '';
                                                } else {
                                                  Map<String, dynamic> resultTambon = tambonList
                                                      .firstWhere((element) => element['id'] == resultList[i]['SubDistrict'], orElse: () => {});
                                                  tambonName = resultTambon['name_th'] ?? '';
                                                }
                                                //====================================================================
                                                addressThai.add({
                                                  'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
                                                  'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
                                                  'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
                                                });

                                                print(addressThai);

                                                String texttt =
                                                    '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                // textList[i]!.add(text.trimLeft());
                                                addressAllForDropdown.add(texttt.trimLeft());
                                              }
                                            });
                                            print(addressAllForDropdown);
                                            toSetState();
                                          },
                                          focusNode: textFieldFocusPhone![index],
                                          autofocus: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
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
                                          style: FlutterFlowTheme.of(context).bodyMedium,
                                          textAlign: TextAlign.start,
                                          validator: _model.textController15Validator.asValidator(context),
                                        ),
                                        // SizedBox(
                                        //   height: 10,
                                        // ),
                                        //======================= ละติจูด ลองติจูด ======================================
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Text(
                                              //   ' ละติดจูด ลองติจูด สามารถค้นหาได้จากการค้นหาในแผนที่ ลำดับที่ ${index + 1}',
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
                                                        // print(index);
                                                        // print(resultList[index]
                                                        // ['Latitude']);

                                                        addressAllForDropdown.clear();

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
                                                          //====================================================================
                                                          List<Map<String, dynamic>> addressThai = [];

                                                          // List<String?>? textList = [];
                                                          for (int i = 0; i < resultList.length; i++) {
                                                            // resultList.add(false);

                                                            List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

                                                            List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
                                                            List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
                                                            String? provincesName;
                                                            String? amphorName;
                                                            String? tambonName;

                                                            //====================================================================
                                                            if (resultList[i]['Province'] == '' || resultList[i]['Province'] == null) {
                                                              provincesName = '';
                                                            } else {
                                                              Map<String, dynamic> resultProvince = mapProvincesList.firstWhere(
                                                                  (element) => element['id'] == resultList[i]['Province'],
                                                                  orElse: () => {});

                                                              provincesName = resultProvince['name_th'] ?? '';
                                                            }
                                                            //====================================================================
                                                            if (resultList[i]['District'] == '' || resultList[i]['District'] == null) {
                                                              amphorName = '';
                                                            } else {
                                                              Map<String, dynamic> resultAmphure = mapList.firstWhere(
                                                                  (element) => element['id'] == resultList[i]['District'],
                                                                  orElse: () => {});

                                                              amphorName = resultAmphure['name_th'] ?? '';
                                                            }

                                                            //====================================================================
                                                            if (resultList[i]['SubDistrict'] == '' || resultList[i]['SubDistrict'] == null) {
                                                              tambonName = '';
                                                            } else {
                                                              Map<String, dynamic> resultTambon = tambonList.firstWhere(
                                                                  (element) => element['id'] == resultList[i]['SubDistrict'],
                                                                  orElse: () => {});
                                                              tambonName = resultTambon['name_th'] ?? '';
                                                            }
                                                            //====================================================================
                                                            addressThai.add({
                                                              'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
                                                              'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
                                                              'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
                                                            });

                                                            print(addressThai);

                                                            String texttt =
                                                                '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                            // textList[i]!.add(text.trimLeft());
                                                            addressAllForDropdown.add(texttt.trimLeft());
                                                          }
                                                        });
                                                        toSetState();
                                                      },
                                                      focusNode: textFieldFocusLatitude![index],
                                                      autofocus: true,
                                                      obscureText: false,
                                                      decoration: InputDecoration(
                                                        isDense: true,
                                                        labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                                        labelText: 'ละติจูด',
                                                        hintText: 'ละติจูด',
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
                                                        print(index);
                                                        print(resultList[index]['Longitude']);

                                                        addressAllForDropdown.clear();

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
                                                          //====================================================================
                                                          List<Map<String, dynamic>> addressThai = [];

                                                          // List<String?>? textList = [];
                                                          for (int i = 0; i < resultList.length; i++) {
                                                            // resultList.add(false);

                                                            List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

                                                            List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
                                                            List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
                                                            String? provincesName;
                                                            String? amphorName;
                                                            String? tambonName;

                                                            //====================================================================
                                                            if (resultList[i]['Province'] == '' || resultList[i]['Province'] == null) {
                                                              provincesName = '';
                                                            } else {
                                                              Map<String, dynamic> resultProvince = mapProvincesList.firstWhere(
                                                                  (element) => element['id'] == resultList[i]['Province'],
                                                                  orElse: () => {});

                                                              provincesName = resultProvince['name_th'] ?? '';
                                                            }
                                                            //====================================================================
                                                            if (resultList[i]['District'] == '' || resultList[i]['District'] == null) {
                                                              amphorName = '';
                                                            } else {
                                                              Map<String, dynamic> resultAmphure = mapList.firstWhere(
                                                                  (element) => element['id'] == resultList[i]['District'],
                                                                  orElse: () => {});

                                                              amphorName = resultAmphure['name_th'] ?? '';
                                                            }

                                                            //====================================================================
                                                            if (resultList[i]['SubDistrict'] == '' || resultList[i]['SubDistrict'] == null) {
                                                              tambonName = '';
                                                            } else {
                                                              Map<String, dynamic> resultTambon = tambonList.firstWhere(
                                                                  (element) => element['id'] == resultList[i]['SubDistrict'],
                                                                  orElse: () => {});
                                                              tambonName = resultTambon['name_th'] ?? '';
                                                            }
                                                            //====================================================================
                                                            addressThai.add({
                                                              'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
                                                              'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
                                                              'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
                                                            });

                                                            print(addressThai);

                                                            String texttt =
                                                                '${resultList[i]['HouseNumber']} ${resultList[i]['VillageName']} ${addressThai[i]['province_name']} ${addressThai[i]['amphure_name']} ${addressThai[i]['tambon_name']}';

                                                            // textList[i]!.add(text.trimLeft());
                                                            addressAllForDropdown.add(texttt.trimLeft());
                                                          }
                                                        });
                                                        toSetState();
                                                      },
                                                      focusNode: textFieldFocusLongitude![index],
                                                      autofocus: true,
                                                      obscureText: false,
                                                      decoration: InputDecoration(
                                                        isDense: true,
                                                        labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                                        labelText: 'ลองติจูด',
                                                        hintText: 'ลองติจูด',
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

                                        //======================= รูปภาพอ้างอิง ======================================
                                        Align(
                                          alignment: AlignmentDirectional(0.00, 0.00),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                            child: FlutterFlowDropDown<String>(
                                              controller: dropDownControllersimageAddress[index],
                                              options: imageAddressAllForDropdown,
                                              onChanged: (val) => setState(() {
                                                String result = val!.replaceAll(RegExp(r'[^0-9]'), '');
                                                print('rrrr');
                                                print(result);
                                                resultList[index]['Image'] = result;
                                              }),
                                              height: 55.0,
                                              textStyle: FlutterFlowTheme.of(context).bodyMedium,
                                              hintText: 'เลือก 1 รูปภาพไว้อ้างอิงร้านค้า',
                                              icon: Icon(
                                                Icons.arrow_left_outlined,
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                size: 24.0,
                                              ),
                                              elevation: 2.0,
                                              borderColor: checkSummit ? Colors.red.shade700 : FlutterFlowTheme.of(context).alternate,
                                              borderWidth: 2.0,
                                              borderRadius: 8.0,
                                              margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                                              hidesUnderline: true,
                                              isSearchable: false,
                                              isMultiSelect: false,
                                            ),
                                          ),
                                        ),
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
                          }),
                          //==================== ตารางราคา API =========================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
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
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('ตารางราคา').snapshots(),
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

                                Map<String, dynamic> priceTable = {};
                                List<String> priceTableName = [];

                                for (int index = 0; index < snapshot.data!.docs.length; index++) {
                                  final Map<String, dynamic> docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                                  if (docData['PLIST_DESC2'] != '') {
                                    priceTable['key${index}'] = docData;
                                    priceTableName.add(docData['PLIST_DESC2']);
                                  }
                                }

                                return Align(
                                  alignment: AlignmentDirectional(0.00, 0.00),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                                    child: FlutterFlowDropDown<String>(
                                      controller: _model.dropDownValueController6 ??= FormFieldController<String>(null),
                                      options: priceTableName,
                                      //  [
                                      //   'ตารางราคา 1',
                                      //   'ตารางราคา 2',
                                      //   'ตารางราคา 3'
                                      // ],
                                      onChanged: (val) => setState(() => _model.dropDownValue6 = val),
                                      height: 55.0,
                                      textStyle: FlutterFlowTheme.of(context).bodyMedium,
                                      hintText: 'ตารางราคา (MFOOD API) (เพื่อใช้ผูกกับที่อยู่ในการจัดส่ง)',
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
                                  ),
                                );
                              }),
                          //========================== หัวข้อ แผนที่ ===================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'พิกัด GPS (Google Map Pin location)',
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                                  child: Icon(
                                    FFIcons.kstoreMarker,
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    size: 24.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //======================= แผนที่ ======================================
                          StatefulBuilder(builder: (context, setState) {
                            return Align(
                              alignment: AlignmentDirectional(0.00, 0.00),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
                                child: Stack(
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
                                        // onTap: (argument) async => await _launchUrl(),
                                        onTap: (argument) async {
                                          await mapDialog(context, resultList).whenComplete(() {
                                            double lat = double.parse(resultList[0]['Latitude']);
                                            double lot = double.parse(resultList[0]['Longitude']!);
                                            _kGooglePlex.isBlank;

                                            _kGooglePlex = CameraPosition(
                                              target: google_maps.LatLng(lat, lot),
                                              zoom: 15,
                                            );
                                            markers.clear();
                                            markers.add(
                                              Marker(
                                                markerId: MarkerId("your_marker_id"),
                                                position: google_maps.LatLng(lat, lot),
                                                infoWindow: InfoWindow(
                                                  title: _model.textController18.text, // ชื่อของปักหมุด
                                                  // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
                                                ),
                                              ),
                                            );
                                            // _mapKey = GlobalKey();
                                            // _mapController.future;
                                          }).then((value) {
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          });
                                          // await showQucikAlertMap(
                                          //     innerContext, resultList);

                                          // print(resultList);
                                        },
                                        // mapType: MapType.hybrid,
                                        // initialCameraPosition: _kGooglePlex,
                                        // onMapCreated: (GoogleMapController controller) {
                                        //   _controller.complete(controller);
                                        // },
                                        // key: _mapKey,
                                        mapType: ui_maps.MapType.hybrid,
                                        initialCameraPosition: _kGooglePlex,
                                        markers: markers, // เพิ่มนี่
                                        onMapCreated: (GoogleMapController controller) {
                                          // controller.moveCamera(
                                          //     CameraUpdate.newLatLng(
                                          //         google_maps.LatLng(
                                          //             double.parse(resultList[0]
                                          //                 ['Latitude']),
                                          //             double.parse(resultList[0]
                                          //                 ['Longitude']))));
                                          // _mapController.complete(controller);
                                          // Set the initial camera position when the map is created
                                        },
                                      ),
                                    ),
                                    //=============================================================
                                    GestureDetector(
                                      onTap: () async {
                                        // await showQucikAlertMap(
                                        //     innerContext, resultList);
                                        await mapDialog(context, resultList);

                                        double lat = double.parse(resultList[0]['Latitude']);
                                        double lot = double.parse(resultList[0]['Longitude']!);

                                        _kGooglePlex = CameraPosition(
                                          target: google_maps.LatLng(lat, lot),
                                          zoom: 14.4746,
                                        );
                                        markers.clear();
                                        markers.add(
                                          Marker(
                                            markerId: MarkerId("your_marker_id"),
                                            position: google_maps.LatLng(lat, lot),
                                            infoWindow: InfoWindow(
                                              title: _model.textController18.text, // ชื่อของปักหมุด
                                              // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
                                            ),
                                          ),
                                        );
                                        // _mapKey = GlobalKey();

                                        if (mounted) {
                                          setState(() {});
                                        }
                                        // print(resultList);
                                      },
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(30.0, 15.0, 30.0, 5.0),
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
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            // await showQucikAlertMap(
                                                            //     innerContext,
                                                            //     resultList);
                                                            await mapDialog(context, resultList);

                                                            double lat = double.parse(resultList[0]['Latitude']);
                                                            double lot = double.parse(resultList[0]['Longitude']!);

                                                            _kGooglePlex = CameraPosition(
                                                              target: google_maps.LatLng(lat, lot),
                                                              zoom: 14.4746,
                                                            );
                                                            markers.clear();
                                                            markers.add(
                                                              Marker(
                                                                markerId: MarkerId("your_marker_id"),
                                                                position: google_maps.LatLng(lat, lot),
                                                                infoWindow: InfoWindow(
                                                                  title: _model.textController18.text, // ชื่อของปักหมุด
                                                                  // snippet: "Your Marker Description", // คำอธิบายของปักหมุด
                                                                ),
                                                              ),
                                                            );
                                                            // _mapKey =
                                                            //     GlobalKey();

                                                            if (mounted) {
                                                              setState(() {});
                                                            }
                                                          },
                                                          child: TextFormField(
                                                            enabled: false,
                                                            // controller: _model
                                                            //     .textController18,
                                                            // focusNode: _model
                                                            //     .textFieldFocusNode18,
                                                            autofocus: true,
                                                            obscureText: false,
                                                            decoration: InputDecoration(
                                                              isDense: true,
                                                              labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                                              hintText: '        ค้นหาสถานที่',
                                                              hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                                    fontFamily: 'Kanit',
                                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                                  ),
                                                              enabledBorder: InputBorder.none,
                                                              focusedBorder: InputBorder.none,
                                                              errorBorder: InputBorder.none,
                                                              focusedErrorBorder: InputBorder.none,
                                                              // suffixIcon: Icon(
                                                              //   Icons.search_sharp,
                                                              // ),
                                                            ),
                                                            style: FlutterFlowTheme.of(context).bodyMedium,
                                                            textAlign: TextAlign.center,
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
                            );
                          }),
                          //========================= หัวข้อ รูปภาพร้านค้า ====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
                                  child: Text(
                                    'รูปภาพร้านค้า อัพโหลดได้หลายภาพ (ต้องมีอย่างน้อย 1 รูป)',
                                    style: FlutterFlowTheme.of(context).bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //==========================  รูปถ่ายร้านค้า  ===================================
                          imageFile.length > 3
                              ? Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(0.00, 0.00),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 8.0, 5.0),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.63,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).accent3,
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width * 0.63 +
                                                      (((MediaQuery.of(context).size.width * 0.63) / 4.5) * (imageUrl.length - 2)),
                                                  height: 100,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      ListView.builder(
                                                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                                        shrinkWrap: true,
                                                        scrollDirection: Axis.horizontal,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: imageUint8List.length,
                                                        itemBuilder: (context, index) {
                                                          return Padding(
                                                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(8),
                                                              child: Stack(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () => showPreviewImage(index, 'memory'),
                                                                    child: Image.memory(
                                                                      imageUint8List[index],
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
                                                                          '${index + 1}/${imageFile.length}',
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
                                                                          imageUint8List.removeAt(index);
                                                                          imageFile.removeAt(index);
                                                                          image!.removeAt(index);
                                                                          imageUrl.removeAt(index);
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
                                                        },
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          // _showPicker(context);
                                                          imageDialog();
                                                          // showQucikAlert(
                                                          //     context);

                                                          // showDialog(
                                                          //   context:
                                                          //       context,
                                                          //   builder:
                                                          //       (BuildContext
                                                          //           ctx) {
                                                          //     return showDialogChooseImage(
                                                          //         context);
                                                          //   },
                                                          // );

                                                          // showDialog(
                                                          //   context:
                                                          //       context,
                                                          //   builder:
                                                          //       (context) {
                                                          //     return Dialog(
                                                          //       child: SizedBox(
                                                          //           height: MediaQuery.of(context).size.height * 0.2,
                                                          //           width: MediaQuery.of(context).size.width * 0.5,
                                                          //           child: cameraOptions()),
                                                          //     );
                                                          //   },
                                                          // );
                                                        },
                                                        child: Container(
                                                          width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
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
                                                                  FFIcons.kpaperclipPlus,
                                                                  color: FlutterFlowTheme.of(context).primaryBackground,
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
                                )
                              : Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Align(
                                        alignment: AlignmentDirectional(0.00, 0.00),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 8.0, 5.0),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.63,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).accent3,
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    imageUrl.length >= 1
                                                        ? Padding(
                                                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(8),
                                                              child: Stack(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () => showPreviewImage(0, 'memory'),
                                                                    child: Image.memory(
                                                                      imageUint8List[0],
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
                                                                          '${0 + 1}/${imageFile.length}',
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
                                                                          imageUint8List.removeAt(0);
                                                                          imageFile.removeAt(0);
                                                                          image!.removeAt(0);
                                                                          imageUrl.removeAt(0);
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
                                                          )
                                                        : Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                                                            child: Container(
                                                              width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                              height: 100.0,
                                                              decoration: BoxDecoration(
                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                borderRadius: BorderRadius.circular(0.0),
                                                              ),
                                                              child: Icon(
                                                                FFIcons.kimagePlus,
                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                size: 40.0,
                                                              ),
                                                            ),
                                                          ),
                                                    imageUrl.length >= 2
                                                        ? Padding(
                                                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(8),
                                                              child: Stack(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () => showPreviewImage(1, 'memory'),
                                                                    child: Image.memory(
                                                                      imageUint8List[1],
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
                                                                          '${1 + 1}/${imageFile.length}',
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
                                                                          imageUint8List.removeAt(1);
                                                                          imageFile.removeAt(1);
                                                                          image!.removeAt(1);
                                                                          imageUrl.removeAt(1);
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
                                                          )
                                                        : Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                                                            child: Container(
                                                              width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                              height: 100.0,
                                                              decoration: BoxDecoration(
                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                borderRadius: BorderRadius.circular(0.0),
                                                              ),
                                                              child: Icon(
                                                                FFIcons.kimagePlus,
                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                size: 40.0,
                                                              ),
                                                            ),
                                                          ),
                                                    imageUrl.length >= 3
                                                        ? Padding(
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
                                                          )
                                                        : Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 6.0, 0.0),
                                                            child: Container(
                                                              width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                              height: 100.0,
                                                              decoration: BoxDecoration(
                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                borderRadius: BorderRadius.circular(0.0),
                                                              ),
                                                              child: Icon(
                                                                FFIcons.kimagePlus,
                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                size: 40.0,
                                                              ),
                                                            ),
                                                          ),
                                                    Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          // _showPicker(context);
                                                          imageDialog();
                                                          // showQucikAlert(
                                                          //     context);

                                                          // showDialog(
                                                          //   context:
                                                          //       context,
                                                          //   builder:
                                                          //       (BuildContext
                                                          //           ctx) {
                                                          //     return showDialogChooseImage(
                                                          //         context);
                                                          //   },
                                                          // );

                                                          // showDialog(
                                                          //   context:
                                                          //       context,
                                                          //   builder:
                                                          //       (context) {
                                                          //     return Dialog(
                                                          //       child: SizedBox(
                                                          //           height: MediaQuery.of(context).size.height * 0.2,
                                                          //           width: MediaQuery.of(context).size.width * 0.5,
                                                          //           child: cameraOptions()),
                                                          //     );
                                                          //   },
                                                          // );
                                                        },
                                                        child: Container(
                                                          width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
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
                                                                  FFIcons.kpaperclipPlus,
                                                                  color: FlutterFlowTheme.of(context).primaryBackground,
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
                                                      // child: GestureDetector(
                                                      //   onTap: () =>
                                                      //       showQucikAlert(
                                                      //           context),
                                                      //   child: Container(
                                                      //     width: (MediaQuery.of(
                                                      //                     context)
                                                      //                 .size
                                                      //                 .width *
                                                      //             0.63) /
                                                      //         4.5,
                                                      //     height: 100.0,
                                                      //     decoration: BoxDecoration(
                                                      //         // color: FlutterFlowTheme
                                                      //         //         .of(context)
                                                      //         //     .primaryText,
                                                      //         // shape: BoxShape.circle,
                                                      //         ),
                                                      //     child: Padding(
                                                      //       padding:
                                                      //           EdgeInsetsDirectional
                                                      //               .fromSTEB(
                                                      //                   10.0,
                                                      //                   10.0,
                                                      //                   10.0,
                                                      //                   10.0),
                                                      //       child: CircleAvatar(
                                                      //         maxRadius: 50,
                                                      //         backgroundColor:
                                                      //             Colors.black,
                                                      //         child: Icon(
                                                      //           FFIcons
                                                      //               .kpaperclipPlus,
                                                      //           color: FlutterFlowTheme.of(
                                                      //                   context)
                                                      //               .primaryBackground,
                                                      //           size: 30.0,
                                                      //         ),
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // ),
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
                          StatefulBuilder(
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
                                            // controller: _model
                                            //         .dropDownValueController7 ??=
                                            //     FormFieldController<String>(null),
                                            options: addressAllForDropdown,
                                            //  ['ที่อยู่ 1', 'ที่อยู่ 2', 'ที่อยู่ 3'],
                                            onChanged: (val) => setState(() {
                                              resultListSendAndBill[index]['ที่อยู่จัดส่ง'] = val;
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
                                            margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
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
                                                ' กำหนดที่อยู่ในการออกบิล',
                                                style: FlutterFlowTheme.of(context).bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        //======================== ที่อยู่ กำหนดที่อยูในการออกบิล =====================================
                                        //=========================== วงเงินเครดิต ==================================
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                                          child: TextFormField(
                                            controller: sendAndBillList![index],

                                            // controller: _model.textController15,
                                            focusNode: textFieldFocusSendAndBill![index],
                                            autofocus: true,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                              labelText: 'ชื่อจ่าหน้าที่อยู่ในการออกบิล',
                                              hintText: 'ชื่อจ่าหน้าที่อยู่ในการออกบิล',
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
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                                          child: FlutterFlowDropDown<String>(
                                            controller: dropDownControllersBill[index],
                                            options: addressAllForDropdown,
                                            //  ['ที่อยู่ 1', 'ที่อยู่ 2', 'ที่อยู่ 3'],
                                            onChanged: (val) => setState(() {
                                              resultListSendAndBill[index]['ที่อยู่ออกบิล'] = val;
                                              print(index);
                                              print(resultListSendAndBill[index]['ที่อยู่ออกบิล']);
                                            }
                                                // _model.dropDownValue8 = val
                                                ),
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
                                            margin: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
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
                          ),
                          //======================== ระยะเวลาชำระหนี้ =====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
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
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                            child: FlutterFlowDropDown<String>(
                              controller: _model.dropDownValueController10 ??= FormFieldController<String>(null),
                              options: ['3 เดือน', '6 เดือน', '12 เดือน'],
                              onChanged: (val) => setState(() => _model.dropDownValue10 = val),
                              height: 55.0,
                              textStyle: FlutterFlowTheme.of(context).bodyMedium,
                              hintText: 'ระยะเวลาชำระหนี้ (Credit terms)',
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
                          ),
                          //=========================== วงเงินเครดิต ==================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                            child: TextFormField(
                              controller: _model.textController19,
                              focusNode: _model.textFieldFocusNode19,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                labelText: 'วงเงินเครดิต (กรณีไม่มีการกำหนดเครดิตให้ใสเป็น 0 ค่าเริ่มต้น',
                                hintText: 'วงเงินเครดิต (กรณีไม่มีการกำหนดเครดิตให้ใสเป็น 0 ค่าเริ่มต้น',
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
                              validator: _model.textController19Validator.asValidator(context),
                            ),
                          ),
                          //=========================  สวนลดท้ายบิล ====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                            child: TextFormField(
                              controller: _model.textController20,
                              focusNode: _model.textFieldFocusNode20,
                              autofocus: true,
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
                          ),
                          //=========================  ประเภทการจ่ายเงิน ====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
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
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('ประเภทการจ่ายเงิน').snapshots(),
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
                                List<String> dropdown = [];

                                for (int index = 0; index < snapshot.data!.docs.length; index++) {
                                  final Map<String, dynamic> docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                                  if (docData['PAYMENT_DESC'] != '') {
                                    data['key${index}'] = docData;
                                    dropdown.add(docData['PAYMENT_DESC']);
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                                  child: FlutterFlowDropDown<String>(
                                    controller: _model.dropDownValueController11 ??= FormFieldController<String>(null),
                                    options: dropdown,
                                    //  [
                                    //   'เงินสด',
                                    //   'โอนผ่านบัญชี',
                                    //   'Gb Pay'
                                    // ],
                                    onChanged: (val) => setState(() => _model.dropDownValue11 = val),
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
                              }),
                          //======================= เงื่อนไขการชำระเงิน ======================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
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
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('เงื่อนไขการชำระเงิน').snapshots(),
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
                                List<String> dropdown = [];

                                for (int index = 0; index < snapshot.data!.docs.length; index++) {
                                  final Map<String, dynamic> docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                                  if (docData['PTERM_DESC'] != '' && docData['IS_ACTIVE'] == true) {
                                    data['key${index}'] = docData;
                                    dropdown.add(docData['PTERM_DESC']);
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                                  child: FlutterFlowDropDown<String>(
                                    controller: _model.dropDownValueController12 ??= FormFieldController<String>(null),
                                    // options: ['มัดจำ 50%', 'มัดจำ 60%', 'มัดจำ 70%'],
                                    options: dropdown,
                                    onChanged: (val) => setState(() => _model.dropDownValue12 = val),
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
                              }),
                          //====================== เลือกบัญชีธนาคารของบริษัท =======================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
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
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('บัญชีธนาคารของบริษัท').snapshots(),
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
                                List<String> dropdown = [];

                                for (int index = 0; index < snapshot.data!.docs.length; index++) {
                                  final Map<String, dynamic> docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                                  if (docData['BBOOK_DESC'] != '' && docData['RESULT'] == true) {
                                    data['key${index}'] = docData;
                                    dropdown.add(docData['BBOOK_DESC']);
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                                  child: FlutterFlowDropDown<String>(
                                    controller: _model.dropDownValueController13 ??= FormFieldController<String>(null),
                                    options: dropdown,
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
                              }),
                          //========================= แผนก ====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
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
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('แผนก').snapshots(),
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
                                List<String> dropdown = [];

                                for (int index = 0; index < snapshot.data!.docs.length; index++) {
                                  final Map<String, dynamic> docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                                  if (docData['DEPARTMENT_NAME'] != '' && docData['IS_ACTIVE'] == true) {
                                    data['key${index}'] = docData;
                                    dropdown.add(docData['DEPARTMENT_NAME']);
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                                  child: FlutterFlowDropDown<String>(
                                    controller: _model.dropDownValueController14 ??= FormFieldController<String>(null),
                                    options: dropdown,
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
                              }),
                          //======================== รหัสบัญชี =====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
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
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('รหัสบัญชี').snapshots(),
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
                                List<String> dropdown = [];

                                for (int index = 0; index < snapshot.data!.docs.length; index++) {
                                  final Map<String, dynamic> docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                                  if (docData['ACC_DESC'] != '') {
                                    data['key${index}'] = docData;
                                    dropdown.add(docData['ACC_DESC']);
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                                  child: FlutterFlowDropDown<String>(
                                    controller: _model.dropDownValueController15 ??= FormFieldController<String>(null),
                                    options: dropdown,
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
                              }),
                          //========================  รหัสพนักงาน =====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
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
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                            child: IgnorePointer(
                              child: TextFormField(
                                readOnly: true,
                                // controller: _model.textController1Company,
                                // focusNode: _model.textFieldFocusNode1Company,
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  label: Text(userData!['EmployeeID']),
                                  // labelText: 'ชื่อบริษัn',
                                  isDense: true,
                                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                  hintText: userData!['EmployeeID'],
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
                          ),
                          //========================  ชื่อ-สกุล พนักงาน  =====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
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
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                            child: IgnorePointer(
                              child: TextFormField(
                                readOnly: true,
                                // controller: _model.textController1Company,
                                // focusNode: _model.textFieldFocusNode1Company,
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  label: Text(userData!['Name'] + ' ' + userData!['Surname']),
                                  // labelText: 'ชื่อบริษัn',
                                  isDense: true,
                                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                  hintText: userData!['Name'] + ' ' + userData!['Surname'],
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
                          ),
                          //======================== รหัสกลุ่มลูกค้า =====================================
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' รหัสกลุ่มลูกค้า กลุ่ม 1 / MFOOD API\' (Require กลุ่มลูกค้า 1 ต้องเลือกข้อมูล)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('รหัสกลุ่มลูกค้าที่1').snapshots(),
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
                                List<String> dropdown = [];

                                for (int index = 0; index < snapshot.data!.docs.length; index++) {
                                  final Map<String, dynamic> docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                                  if (docData['GROUP_DESC'] != '' && docData['IS_ACTIVE'] == true) {
                                    data['key${index}'] = docData;
                                    dropdown.add(docData['GROUP_DESC']);
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                                  child: FlutterFlowDropDown<String>(
                                    controller: _model.dropDownValueController18 ??= FormFieldController<String>(null),
                                    options: dropdown,
                                    onChanged: (val) => setState(() => _model.dropDownValue18 = val),
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
                              }),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' รหัสกลุ่มลูกค้า กลุ่ม 2 / MFOOD API\' (Require กลุ่มลูกค้า 1 ต้องเลือกข้อมูล)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('รหัสกลุ่มลูกค้าที่2').snapshots(),
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
                                List<String> dropdown = [];

                                for (int index = 0; index < snapshot.data!.docs.length; index++) {
                                  final Map<String, dynamic> docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                                  if (docData['GROUP_DESC'] != '' && docData['IS_ACTIVE'] == true) {
                                    data['key${index}'] = docData;
                                    dropdown.add(docData['GROUP_DESC']);
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                                  child: FlutterFlowDropDown<String>(
                                    controller: _model.dropDownValueController182 ??= FormFieldController<String>(null),
                                    options: dropdown,
                                    onChanged: (val) => setState(() => _model.dropDownValue182 = val),
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
                              }),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' รหัสกลุ่มลูกค้า กลุ่ม 3 / MFOOD API\' (Require กลุ่มลูกค้า 1 ต้องเลือกข้อมูล)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('รหัสกลุ่มลูกค้าที่3').snapshots(),
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
                                List<String> dropdown = [];

                                for (int index = 0; index < snapshot.data!.docs.length; index++) {
                                  final Map<String, dynamic> docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                                  if (docData['GROUP_DESC'] != '' && docData['IS_ACTIVE'] == true) {
                                    data['key${index}'] = docData;
                                    dropdown.add(docData['GROUP_DESC']);
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                                  child: FlutterFlowDropDown<String>(
                                    controller: _model.dropDownValueController183 ??= FormFieldController<String>(null),
                                    options: dropdown,
                                    onChanged: (val) => setState(() => _model.dropDownValue183 = val),
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
                              }),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' รหัสกลุ่มลูกค้า กลุ่ม 4 / MFOOD API\' (Require กลุ่มลูกค้า 1 ต้องเลือกข้อมูล)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('รหัสกลุ่มลูกค้าที่4').snapshots(),
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
                                List<String> dropdown = [];

                                for (int index = 0; index < snapshot.data!.docs.length; index++) {
                                  final Map<String, dynamic> docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                                  if (docData['GROUP_DESC'] != '' && docData['IS_ACTIVE'] == true) {
                                    data['key${index}'] = docData;
                                    dropdown.add(docData['GROUP_DESC']);
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                                  child: FlutterFlowDropDown<String>(
                                    controller: _model.dropDownValueController184 ??= FormFieldController<String>(null),
                                    options: dropdown,
                                    onChanged: (val) => setState(() => _model.dropDownValue184 = val),
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
                              }),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  ' รหัสกลุ่มลูกค้า กลุ่ม 5 / MFOOD API\' (Require กลุ่มลูกค้า 1 ต้องเลือกข้อมูล)',
                                  style: FlutterFlowTheme.of(context).bodySmall,
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('รหัสกลุ่มลูกค้าที่5').snapshots(),
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
                                List<String> dropdown = [];

                                for (int index = 0; index < snapshot.data!.docs.length; index++) {
                                  final Map<String, dynamic> docData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                                  if (docData['GROUP_DESC'] != '' && docData['IS_ACTIVE'] == true) {
                                    data['key${index}'] = docData;
                                    dropdown.add(docData['GROUP_DESC']);
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 5.0),
                                  child: FlutterFlowDropDown<String>(
                                    controller: _model.dropDownValueController185 ??= FormFieldController<String>(null),
                                    options: dropdown,
                                    onChanged: (val) => setState(() => _model.dropDownValue185 = val),
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
                              }),
                          // //=========================  รหัสบัญชี  ====================================
                          // widget.type == 'company'
                          //     ? SizedBox()
                          //     : Padding(
                          //         padding: EdgeInsetsDirectional.fromSTEB(
                          //             8.0, 5.0, 0.0, 0.0),
                          //         child: Row(
                          //           mainAxisSize: MainAxisSize.max,
                          //           children: [
                          //             Text(
                          //               ' รหัสกลุ่มลูกค้า กลุ่ม 1 - 5 (dropdown) / MFOOD API\' (Require กลุ่มลูกค้า 1 ต้องเลือกข้อมูล)',
                          //               style: FlutterFlowTheme.of(context)
                          //                   .bodySmall,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          // widget.type == 'company'
                          //     ? SizedBox()
                          //     : Padding(
                          //         padding: EdgeInsetsDirectional.fromSTEB(
                          //             8.0, 0.0, 8.0, 5.0),
                          //         child: FlutterFlowDropDown<String>(
                          //           controller:
                          //               _model.dropDownValueController19 ??=
                          //                   FormFieldController<String>(null),
                          //           options: [
                          //             'รหัสบัญชี   1',
                          //             'รหัสบัญชี   2',
                          //             'รหัสบัญชี   3'
                          //           ],
                          //           onChanged: (val) => setState(
                          //               () => _model.dropDownValue19 = val),
                          //           height: 55.0,
                          //           textStyle:
                          //               FlutterFlowTheme.of(context).bodyMedium,
                          //           hintText: 'รหัสบัญชี (MFOOD API)',
                          //           icon: Icon(
                          //             Icons.arrow_left_outlined,
                          //             color: FlutterFlowTheme.of(context)
                          //                 .secondaryText,
                          //             size: 24.0,
                          //           ),
                          //           elevation: 2.0,
                          //           borderColor:
                          //               FlutterFlowTheme.of(context).alternate,
                          //           borderWidth: 2.0,
                          //           borderRadius: 8.0,
                          //           margin: EdgeInsetsDirectional.fromSTEB(
                          //               16.0, 4.0, 16.0, 4.0),
                          //           hidesUnderline: true,
                          //           isSearchable: false,
                          //           isMultiSelect: false,
                          //         ),
                          //       ),
                          //======================  รูปสำหรับเอกสาร =======================================
                          StatefulBuilder(builder: (context, setState) {
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
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
                                            color: imageUint8ListList2![0]!.isEmpty && finalFileResultString![0]!.isEmpty
                                                ? Colors.grey.shade500
                                                : Colors.green.shade900,
                                            size: 15.0,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            widget.type == 'company' ? '1) สําเนาบัตรประชาชนของกรรมการ (บังคับ)' : '1) สําเนาบัตรประชาชน (บังคับ)',
                                            style: FlutterFlowTheme.of(context).bodyMedium,
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              imageDialog2(
                                                widget.type == 'company' ? '(สําเนาบัตรประชาชนของกรรมการ)' : '(สําเนาบัตรประชาชน)',
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
                                      for (int index = 0; index < finalFileResultString![0]!.length; index++)
                                        Container(
                                          color: null,
                                          width: 600,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  OpenFile.open(finalFileResultString![0]![index]);
                                                },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      '- ไฟล์ที่ ${index + 1}',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
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
                                            color: imageUint8ListList2![1]!.isEmpty && finalFileResultString![1]!.isEmpty
                                                ? Colors.grey.shade500
                                                : Colors.green.shade900,
                                            size: 15.0,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            widget.type == 'company' ? '2) หนังสือรับรองบริษัทไม่หมดอายุเกิน 6 เดือน (บังคับ)' : '2) ทะเบียนบ้าน',
                                            style: FlutterFlowTheme.of(context).bodyMedium,
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              imageDialog2(
                                                widget.type == 'company' ? '(หนังสือรับรองบริษัทไม่หมดอายุเกิน 6 เดือน)' : '(ทะเบียนบ้าน)',
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
                                      for (int index = 0; index < finalFileResultString![1]!.length; index++)
                                        Container(
                                          color: null,
                                          width: 600,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  OpenFile.open(finalFileResultString![1]![index]);
                                                },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      '- ไฟล์ที่ ${index + 1}',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
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
                                            color: imageUint8ListList2![2]!.isEmpty && finalFileResultString![2]!.isEmpty
                                                ? Colors.grey.shade500
                                                : Colors.green.shade900,
                                            size: 15.0,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            widget.type == 'company'
                                                ? _model.radioButtonValueControllerVat!.value == 'มี'
                                                    ? '3) ภพ.20 (บังคับ)'
                                                    : '3) ภพ.20'
                                                : '3) แผนที่ในการจัดส่งสินค้า (บังคับ)',
                                            style: FlutterFlowTheme.of(context).bodyMedium,
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              imageDialog2(
                                                widget.type == 'company' ? '(ภพ.20)' : '(แผนที่ในการจัดส่งสินค้า)',
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
                                      for (int index = 0; index < finalFileResultString![2]!.length; index++)
                                        Container(
                                          color: null,
                                          width: 600,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  OpenFile.open(finalFileResultString![2]![index]);
                                                },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      '- ไฟล์ที่ ${index + 1}',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
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
                                            color: imageUint8ListList2![3]!.isEmpty && finalFileResultString![3]!.isEmpty
                                                ? Colors.grey.shade500
                                                : Colors.green.shade900,
                                            size: 15.0,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            widget.type == 'company' ? '4) แผนที่ในการจัดส่งสินค้า (บังคับ)' : '4) เอกสารอื่นๆ',
                                            style: FlutterFlowTheme.of(context).bodyMedium,
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              imageDialog2(
                                                widget.type == 'company' ? '(แผนที่ในการจัดส่งสินค้า)' : '(เอกสารอื่นๆ)',
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
                                      for (int index = 0; index < finalFileResultString![3]!.length; index++)
                                        Container(
                                          color: null,
                                          width: 600,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  OpenFile.open(finalFileResultString![3]![index]);
                                                },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      '- ไฟล์ที่ ${index + 1}',
                                                      style: FlutterFlowTheme.of(context).bodyMedium,
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
                                  widget.type == 'company'
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: imageUint8ListList2![4]!.isEmpty && finalFileResultString![4]!.isEmpty
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
                                            for (int index = 0; index < finalFileResultString![4]!.length; index++)
                                              Container(
                                                color: null,
                                                width: 600,
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        OpenFile.open(finalFileResultString![4]![index]);
                                                      },
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            '- ไฟล์ที่ ${index + 1}',
                                                            style: FlutterFlowTheme.of(context).bodyMedium,
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
                                                            finalFileResultString![4]!.removeAt(index);
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
                                  // imageFile2.length > 3
                                  //     ?
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
                                              width: MediaQuery.of(context).size.width * 0.63,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(context).accent3,
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Container(
                                                    width: (MediaQuery.of(context).size.width * 0.63 +
                                                            (((MediaQuery.of(context).size.width * 0.63) / 4.5) *
                                                                (imageUint8ListList2![0]!.length - 2))) +
                                                        (MediaQuery.of(context).size.width * 0.63 +
                                                            (((MediaQuery.of(context).size.width * 0.63) / 4.5) *
                                                                (imageUint8ListList2![1]!.length - 2))) +
                                                        (MediaQuery.of(context).size.width * 0.63 +
                                                            (((MediaQuery.of(context).size.width * 0.63) / 4.5) *
                                                                (imageUint8ListList2![2]!.length - 2))) +
                                                        (MediaQuery.of(context).size.width * 0.63 +
                                                            (((MediaQuery.of(context).size.width * 0.63) / 4.5) *
                                                                (imageUint8ListList2![3]!.length - 2))) +
                                                        (MediaQuery.of(context).size.width * 0.63 +
                                                            (((MediaQuery.of(context).size.width * 0.63) / 4.5) *
                                                                (imageUint8ListList2![4]!.length - 2))),
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
                                                            return Padding(
                                                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(8),
                                                                child: Stack(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () => showPreviewImage2(
                                                                        index,
                                                                        'memory',
                                                                        0,
                                                                      ),
                                                                      child: Image.memory(
                                                                        imageUint8ListList2![0]![index],
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
                                                                            '${index + 1}/${imageFile2.length}',
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
                                                                            imageUint8List2.removeAt(index);
                                                                            imageFile2.removeAt(index);
                                                                            image2!.removeAt(index);
                                                                            imageUrl2.removeAt(index);
                                                                            imageLength2 = imageLength2 - 1;
                                                                            //==========================================
                                                                            imageUint8ListList2![0]!.removeAt(index);

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
                                                            return Padding(
                                                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(8),
                                                                child: Stack(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () => showPreviewImage2(
                                                                        index,
                                                                        'memory',
                                                                        1,
                                                                      ),
                                                                      child: Image.memory(
                                                                        imageUint8ListList2![1]![index],
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
                                                                            '${index + 1 + imageUint8ListList2![0]!.length}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
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
                                                                            imageUint8List2.removeAt(index);
                                                                            imageFile2.removeAt(index);
                                                                            image2!.removeAt(index);
                                                                            imageUrl2.removeAt(index);
                                                                            imageLength2 = imageLength2 - 1;
                                                                            //==========================================
                                                                            imageUint8ListList2![1]!.removeAt(index);

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
                                                            return Padding(
                                                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(8),
                                                                child: Stack(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () => showPreviewImage2(index, 'memory', 2),
                                                                      child: Image.memory(
                                                                        imageUint8ListList2![2]![index],
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
                                                                            '${index + 1 + imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
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
                                                                            imageUint8List2.removeAt(index);
                                                                            imageFile2.removeAt(index);
                                                                            image2!.removeAt(index);
                                                                            imageUrl2.removeAt(index);
                                                                            imageLength2 = imageLength2 - 1;
                                                                            //==========================================
                                                                            imageUint8ListList2![2]!.removeAt(index);

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
                                                            return Padding(
                                                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(8),
                                                                child: Stack(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () => showPreviewImage2(index, 'memory', 3),
                                                                      child: Image.memory(
                                                                        imageUint8ListList2![3]![index],
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
                                                                            '${index + 1 + imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
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
                                                                            imageUint8List2.removeAt(index);
                                                                            imageFile2.removeAt(index);
                                                                            image2!.removeAt(index);
                                                                            imageUrl2.removeAt(index);
                                                                            imageLength2 = imageLength2 - 1;
                                                                            //==========================================
                                                                            imageUint8ListList2![3]!.removeAt(index);

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
                                                            return Padding(
                                                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(8),
                                                                child: Stack(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: () => showPreviewImage2(index, 'memory', 4),
                                                                      child: Image.memory(
                                                                        imageUint8ListList2![4]![index],
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
                                                                            '${index + 1 + imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length}/${imageUint8ListList2![0]!.length + imageUint8ListList2![1]!.length + imageUint8ListList2![2]!.length + imageUint8ListList2![3]!.length + imageUint8ListList2![4]!.length}',
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
                                                                            imageUint8List2.removeAt(index);
                                                                            imageFile2.removeAt(index);
                                                                            image2!.removeAt(index);
                                                                            imageUrl2.removeAt(index);
                                                                            imageLength2 = imageLength2 - 1;
                                                                            //==========================================
                                                                            imageUint8ListList2![4]!.removeAt(index);

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
                                                        for (int i = imageUint8List2.length; i < 4; i++)
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 6.0, 0.0),
                                                            child: Container(
                                                              width: (MediaQuery.of(context).size.width * 0.63) / 4.5,
                                                              height: 100.0,
                                                              decoration: BoxDecoration(
                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                borderRadius: BorderRadius.circular(0.0),
                                                              ),
                                                              child: Icon(
                                                                FFIcons.kimagePlus,
                                                                color: FlutterFlowTheme.of(context).secondaryText,
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
                          }),
                          Align(
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
                                        ),
                                  //========================== ลายเซ็น  ===================================
                                  signConfirm
                                      ? Align(
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
                                        )
                                      : SizedBox()
                                ],
                              );
                            }),
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
              SizedBox(
                height: 10,
              ),
              //========================== เซฟไว้ทำทีหลัง  ===================================
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                child: FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                    trySummit(true);
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
              ),
              //========================== เซฟแล้วดำเนินการต่อไป  ===================================
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 0.0),
                child: FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                    Set<String> uniqueImages = Set<String>();
                    for (int i = 0; i < resultList.length; i++) {
                      if (resultList[i]['Image'].isEmpty || resultList[i]['Image'] == '') {
                        Fluttertoast.showToast(
                          msg: "คุณมีร้านค้า ${resultList.length} สถานที่ กรุณาอ้างอิงรูปภาพในทุกๆ สถานที่\nอย่างน้อย 1 รูปภาพค่ะ",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.red.shade900,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        setState(
                          () => checkSummit = true,
                        );
                        return;
                      }

                      if (!uniqueImages.add(resultList[i]['Image'])) {
                        // ถ้าเจอว่าซ้ำ
                        Fluttertoast.showToast(
                          msg: "รูปภาพอ้างอิงร้านค้า ต้องไม่ซ้ำกันค่ะ",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.red.shade900,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        setState(() => checkSummit = true);
                        return;
                      }
                    }
                    if (widget.type == 'company') {
                      if (_model.radioButtonValueControllerVat!.value == null) {
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

                    if (widget.type == 'company') {
                      if (_model.radioButtonValueControllerVat!.value == 'มี') {
                        // ถ้าเอกสารนิติบุคคลมีvat [true,true,true,true,false]
                        for (int i = 0; i < 4; i++) {
                          if (i == 0) {
                            if (imageUint8ListList2![0]!.isEmpty && finalFileResultString![0]!.isEmpty) {
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
                            if (imageUint8ListList2![1]!.isEmpty && finalFileResultString![1]!.isEmpty) {
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
                            if (imageUint8ListList2![2]!.isEmpty && finalFileResultString![2]!.isEmpty) {
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
                          } else if (i == 3) {
                            if (imageUint8ListList2![3]!.isEmpty && finalFileResultString![3]!.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "คุณยังไม่แนบไฟล์แผนที่ในการจัดส่งสินค้าค่ะ",
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
                          } else {}
                        }
                      } else {
                        // ถ้าเอกสารนิติบุคคลไม่มีvat [true,true,false,true,false]
                        for (int i = 0; i < 4; i++) {
                          if (i == 0) {
                            if (imageUint8ListList2![0]!.isEmpty && finalFileResultString![0]!.isEmpty) {
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
                            if (imageUint8ListList2![1]!.isEmpty && finalFileResultString![1]!.isEmpty) {
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
                          } else if (i == 3) {
                            if (imageUint8ListList2![3]!.isEmpty && finalFileResultString![3]!.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "คุณยังไม่แนบไฟล์แผนที่ในการจัดส่งสินค้าค่ะ",
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
                          } else {}
                        }
                      }
                    } else {
                      // ถ้าเอกสารบุคคลธรรมดา [true,false,true,false,false]
                      for (int i = 0; i < 3; i++) {
                        if (i == 0) {
                          if (imageUint8ListList2![0]!.isEmpty && finalFileResultString![0]!.isEmpty) {
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
                        } else if (i == 2) {
                          if (imageUint8ListList2![2]!.isEmpty && finalFileResultString![2]!.isEmpty) {
                            Fluttertoast.showToast(
                              msg: "คุณยังไม่แนบไฟล์แผนที่ในการจัดส่งสินค้าค่ะ",
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
                        } else {}
                      }
                    }

                    // imageUint8ListList2![index]!.add(imageRead2);finalFileResultString

                    trySummit(false);
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
              ),
            ],
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
                        debugPrint('${sign!.points.length} points in the signature');
                      },
                      backgroundPainter: WatermarkPaint("2.0", "2.0"),
                      strokeWidth: strokeWidth,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final sign = _sign.currentState;
                        //retrieve image data, do whatever you want with it (send to server, save locally...)
                        final imageSign = await sign!.getData();

                        var data = await imageSign.toByteData(format: ui.ImageByteFormat.png);
                        final encoded = base64.encode(data!.buffer.asUint8List());

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
                      imageProvider: NetworkImage(imageUrl2[index]),
                    )
                  : PhotoView(
                      // imageProvider: FileImage(images),
                      imageProvider: MemoryImage(imageUint8ListList2![indexList]![index]),
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

  Future<dynamic> mapDialog(BuildContext context, List<Map<String, dynamic>> address) async {
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

      List<Map<String, dynamic>> mapProvincesList = provinces!.cast<Map<String, dynamic>>();

      List<Map<String, dynamic>> mapList = amphures![i].cast<Map<String, dynamic>>();
      List<Map<String, dynamic>> tambonList = tambons![i].cast<Map<String, dynamic>>();
      String? provincesName;
      String? amphorName;
      String? tambonName;
      print('Check map errorr $i');
//====================================================================
      if (address[i]['Province'] == '' || address[i]['Province'] == null) {
        provincesName = '';
      } else {
        Map<String, dynamic> resultProvince = mapProvincesList.firstWhere((element) => element['id'] == address[i]['Province'], orElse: () => {});

        provincesName = resultProvince['name_th'] ?? '';
      }
//====================================================================
      if (address[i]['District'] == '' || address[i]['District'] == null) {
        amphorName = '';
      } else {
        Map<String, dynamic> resultAmphure = mapList.firstWhere((element) => element['id'] == address[i]['District'], orElse: () => {});

        amphorName = resultAmphure['name_th'] ?? '';
      }

      //====================================================================
      if (address[i]['SubDistrict'] == '' || address[i]['SubDistrict'] == null) {
        tambonName = '';
      } else {
        Map<String, dynamic> resultTambon = tambonList.firstWhere((element) => element['id'] == address[i]['SubDistrict'], orElse: () => {});
        tambonName = resultTambon['name_th'] ?? '';
      }
      //====================================================================
      addressThai.add({
        'province_name': provincesName! == '' ? provincesName : 'จ.' + provincesName,
        'amphure_name': amphorName! == '' ? amphorName : 'อ.' + amphorName,
        'tambon_name': tambonName! == '' ? tambonName : 'ต.' + provincesName,
      });
      print('Check map errorr');
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
                print('Latitude: ${location.latitude}, Longitude: ${location.longitude}');
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
                              onTap: (argument) async {},

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
                              padding: EdgeInsetsDirectional.fromSTEB(30.0, 15.0, 30.0, 5.0),
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
                                                labelStyle: FlutterFlowTheme.of(context).labelMedium,
                                                hintText: '        ค้นหาสถานที่',
                                                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                      fontFamily: 'Kanit',
                                                      color: FlutterFlowTheme.of(context).primaryText,
                                                    ),
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                focusedErrorBorder: InputBorder.none,
                                                // suffixIcon: Icon(
                                                //   Icons.search_sharp,
                                                // ),
                                              ),
                                              style: FlutterFlowTheme.of(context).bodyMedium,
                                              textAlign: TextAlign.center,
                                              validator: _model.textController18Validator.asValidator(context),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // await showQucikAlertMap(
                                            //     context, resultList);
                                            getLatLngFromAddress(_model.textController18.text);
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
                                  BorderSide(color: Colors.red.shade300, width: 1),
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
                                backgroundColor: MaterialStatePropertyAll(Colors.blue.shade900),
                                // side: MaterialStatePropertyAll(
                                // BorderSide(
                                //     color: Colors.red.shade300, width: 1),
                                // ),
                              ),
                              onPressed: () {
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
                              style: FlutterFlowTheme.of(context).headlineMedium,
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
                              style: FlutterFlowTheme.of(context).headlineMedium,
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
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0), // ปรับค่าตามต้องการ
                                ),
                              ),
                              side: MaterialStatePropertyAll(
                                BorderSide(color: Colors.red.shade300, width: 1),
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
                              style: FlutterFlowTheme.of(context).headlineMedium,
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
                              style: FlutterFlowTheme.of(context).headlineMedium,
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
                              style: FlutterFlowTheme.of(context).headlineMedium,
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
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0), // ปรับค่าตามต้องการ
                                ),
                              ),
                              side: MaterialStatePropertyAll(
                                BorderSide(color: Colors.red.shade300, width: 1),
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
                              style: FlutterFlowTheme.of(context).headlineMedium,
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
                              style: FlutterFlowTheme.of(context).headlineMedium,
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
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0), // ปรับค่าตามต้องการ
                                ),
                              ),
                              side: MaterialStatePropertyAll(
                                BorderSide(color: Colors.red.shade300, width: 1),
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
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
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
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0), // ปรับค่าตามต้องการ
                                  ),
                                ),
                                side: MaterialStatePropertyAll(
                                  BorderSide(color: Colors.red.shade300, width: 1),
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
          print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
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
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0), // ปรับค่าตามต้องการ
                                      ),
                                    ),
                                    side: MaterialStatePropertyAll(
                                      BorderSide(color: Colors.red.shade300, width: 1),
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

            HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('readOCR');
            final resultCloudFunction = await callable.call(<String, dynamic>{"imgName": "${fileName}.png"});
            // pd.update(value: 70, msg: "กำลังอ่านข้อมูลบัตรประชาชน 70%");
            List result = [];
            List arMonth = [null, 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];

            print("before: resultCloudFunction.data['textOCR'] => ${resultCloudFunction.data['textOCR']}");
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
                if ((v.endsWith('ber') || v.endsWith('er') || v.startsWith('เล') || v.endsWith('าชน')) && f.isNumeric(result[k + 1])) {
                  textMap['idcard'] = result[k + 1] + result[k + 2] + result[k + 3] + result[k + 4] + result[k + 5];
                } else if (v.startsWith('ชื่อ') || v.startsWith('ชือ') || v.endsWith('สกุล') || v.endsWith('กุล') || v.endsWith('กล')) {
                  if (result[k + 1] == 'นาย' || result[k + 1] == 'พระ') {
                    textMap['sex'] = 1;
                    textMap['sexName'] = "ชาย";
                  } else {
                    textMap['sex'] = 2;
                    textMap['sexName'] = "หญิง";
                  }
                  textMap['name'] = result[k + 2];
                  textMap['surname'] = result[k + 3];
                } else if (v.startsWith('เกิด') || v.startsWith('เก') || v.endsWith('นที่') || v.endsWith('วนี') || v.endsWith('นท่')) {
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
                } else if (v.startsWith('ที่อ') || v.startsWith('ทีอ') || v.endsWith('อยู่')) {
                  textMap['address'] = '${result[k + 1]} ${result[k + 2]} ${result[k + 3]}';
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
              print('-------------------');

              _model.textController1.text = '${textMap['name']} ${textMap['surname']}';
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
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0), // ปรับค่าตามต้องการ
                                      ),
                                    ),
                                    side: MaterialStatePropertyAll(
                                      BorderSide(color: Colors.red.shade300, width: 1),
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
                          style: Theme.of(context).textTheme.titleMedium?.merge(TextStyle(color: Colors.grey, fontFamily: 'Kanit')),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _model.textController2.text = DateFormat('dd').format(_selectDate);
                          _model.textController3.text = DateFormat('MM').format(_selectDate); //budda
                          _model.textController4.text = (int.parse(DateFormat('yyyy').format(_selectDate)) + 543).toString();

                          dateBirthday = _selectDate;
                          Navigator.pop(context);
                        },
                        child: Text(
                          'ตกลง',
                          style: Theme.of(context).textTheme.titleMedium?.merge(TextStyle(color: Colors.blueAccent, fontFamily: 'Kanit')),
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
                    minimumDate: DateTime(DateTime.now().year - 150, DateTime.now().month, DateTime.now().day),
                    maximumDate: DateTime.now(),
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
                          fontFamily: 'Kanit',
                        ),
                        selectedTextStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                          fontFamily: 'Kanit',
                        ),
                        // margin: const EdgeInsets.only(right: 10),
                      ),
                      month: ScrollViewDetailOptions(
                        label: '  ',
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Kanit',
                        ),
                        selectedTextStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                          fontFamily: 'Kanit',
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
