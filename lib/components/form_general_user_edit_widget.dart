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
import 'form_general_user_edit_model.dart';
export 'form_general_user_edit_model.dart';

class FormGeneralUserEditWidget extends StatefulWidget {
  const FormGeneralUserEditWidget({Key? key}) : super(key: key);

  @override
  _FormGeneralUserEditWidgetState createState() =>
      _FormGeneralUserEditWidgetState();
}

class _FormGeneralUserEditWidgetState extends State<FormGeneralUserEditWidget> {
  late FormGeneralUserEditModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FormGeneralUserEditModel());

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

    _model.textController18 ??= TextEditingController();
    _model.textFieldFocusNode18 ??= FocusNode();

    _model.textController19 ??= TextEditingController();
    _model.textFieldFocusNode19 ??= FocusNode();

    _model.textController20 ??= TextEditingController();
    _model.textFieldFocusNode20 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 60.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
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
                    'กรุณาเชื่อมต่ออินเตอร์เน็ต  สามารถเปิดกล้องถ่ายหน้าบัตรและอ่าน ORC ได้จากที่นี่',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ],
              ),
            ),
            Padding(
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
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
              child: TextFormField(
                controller: _model.textController1,
                focusNode: _model.textFieldFocusNode1,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'วันเดือนปีเกิด',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController2,
                        focusNode: _model.textFieldFocusNode2,
                        autofocus: true,
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
                        validator: _model.textController2Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController3,
                        focusNode: _model.textFieldFocusNode3,
                        autofocus: true,
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
                        validator: _model.textController3Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController4,
                        focusNode: _model.textFieldFocusNode4,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          hintText: 'พส',
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
                        validator: _model.textController4Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: TextFormField(
                controller: _model.textController5,
                focusNode: _model.textFieldFocusNode5,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
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
                validator: _model.textController5Validator.asValidator(context),
              ),
            ),
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
                validator: _model.textController6Validator.asValidator(context),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'วัน / เดือน / ปี ที่เริ่มจัดส่ง ',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController7,
                        focusNode: _model.textFieldFocusNode7,
                        autofocus: true,
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
                        validator: _model.textController7Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController8,
                        focusNode: _model.textFieldFocusNode8,
                        autofocus: true,
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
                        validator: _model.textController8Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController9,
                        focusNode: _model.textFieldFocusNode9,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          hintText: 'พส',
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
                        validator: _model.textController9Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                  hintText: 'ชื่อร้าน/แผงในตลาด',
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
                    _model.textController10Validator.asValidator(context),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: TextFormField(
                controller: _model.textController11,
                focusNode: _model.textFieldFocusNode11,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
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
                validator:
                    _model.textController11Validator.asValidator(context),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.00, 0.00),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                child: FlutterFlowDropDown<String>(
                  controller: _model.dropDownValueController1 ??=
                      FormFieldController<String>(null),
                  options: [
                    'ประเภทสินค้า 1',
                    'ประเภทสินค้า 2',
                    'ประเภทสินค้า 3',
                    'ประเภทสินค้า 4',
                    'ประเภทสินค้า 5'
                  ],
                  onChanged: (val) =>
                      setState(() => _model.dropDownValue1 = val),
                  height: 45.0,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium,
                  hintText: 'ประเภทสินค้าที่ขายในปัจจุบัน',
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
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
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
                ],
              ),
            ),
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
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController12,
                        focusNode: _model.textFieldFocusNode12,
                        autofocus: true,
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
                        validator: _model.textController12Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController13,
                        focusNode: _model.textFieldFocusNode13,
                        autofocus: true,
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
                        validator: _model.textController13Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: TextFormField(
                        controller: _model.textController14,
                        focusNode: _model.textFieldFocusNode14,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          hintText: 'พส',
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
                        validator: _model.textController14Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController2 ??=
                    FormFieldController<String>(null),
                options: [
                  'กลุ่มสินค้า 1',
                  'กลุ่มสินค้า 2',
                  'กลุ่มสินค้า 3',
                  'กลุ่มสินค้า 4',
                  'กลุ่มสินค้า 5'
                ],
                onChanged: (val) => setState(() => _model.dropDownValue2 = val),
                height: 45.0,
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
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
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
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'ที่อยูในการจัดสง (ระบุได้มากกวา 1 สถานที่) โดยเลือก จังหวัด ,อำเภอ , ตำบล , รหัสไปรษณีย์',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: TextFormField(
                controller: _model.textController15,
                focusNode: _model.textFieldFocusNode15,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  hintText: 'กรุณาพิมพ์ชื่อบ้านเลขที',
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
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: TextFormField(
                controller: _model.textController16,
                focusNode: _model.textFieldFocusNode16,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
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
                validator:
                    _model.textController16Validator.asValidator(context),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.00, 0.00),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                child: FlutterFlowDropDown<String>(
                  controller: _model.dropDownValueController3 ??=
                      FormFieldController<String>(null),
                  options: ['เชียงใหม่', 'นครราชสีมา', 'กาญจนบุรี'],
                  onChanged: (val) =>
                      setState(() => _model.dropDownValue3 = val),
                  height: 45.0,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium,
                  hintText: 'จังหวัด',
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
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController4 ??=
                    FormFieldController<String>(null),
                options: ['\tเมืองเชียงใหม่', 'จอมทอง', '\tแม่แจ่ม'],
                onChanged: (val) => setState(() => _model.dropDownValue4 = val),
                height: 45.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium,
                hintText: 'อำเภอ',
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController5 ??=
                    FormFieldController<String>(null),
                options: ['\tศรีภูมิ', 'พระสิงห์', 'หายยา\t'],
                onChanged: (val) => setState(() => _model.dropDownValue5 = val),
                height: 45.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium,
                hintText: 'ตำบล',
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: TextFormField(
                controller: _model.textController17,
                focusNode: _model.textFieldFocusNode17,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
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
                validator:
                    _model.textController17Validator.asValidator(context),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
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
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.00, 0.00),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                child: FlutterFlowDropDown<String>(
                  controller: _model.dropDownValueController6 ??=
                      FormFieldController<String>(null),
                  options: ['ตารางราคา 1', 'ตารางราคา 2', 'ตารางราคา 3'],
                  onChanged: (val) =>
                      setState(() => _model.dropDownValue6 = val),
                  height: 45.0,
                  textStyle: FlutterFlowTheme.of(context).bodyMedium,
                  hintText:
                      'ตารางราคา (MFOOD API) (เพื่อใช้ผูกกับที่อยู่ในการจัดสง)',
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
            ),
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.6,
                    height: 25.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).accent3,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: AlignmentDirectional(0.00, 0.00),
                    child: TextFormField(
                      controller: _model.textController18,
                      focusNode: _model.textFieldFocusNode18,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: FlutterFlowTheme.of(context).labelMedium,
                        hintText: 'ค้นหาสถานที่',
                        hintStyle: FlutterFlowTheme.of(context)
                            .labelMedium
                            .override(
                              fontFamily: 'Kanit',
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.search_sharp,
                        ),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      textAlign: TextAlign.center,
                      validator:
                          _model.textController18Validator.asValidator(context),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.00, 0.00),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 10.0, 5.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 500.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(0.0),
                    shape: BoxShape.rectangle,
                  ),
                  child: FlutterFlowGoogleMap(
                    controller: _model.googleMapsController,
                    onCameraIdle: (latLng) => _model.googleMapsCenter = latLng,
                    initialLocation: _model.googleMapsCenter ??=
                        LatLng(13.7120469, 100.7913919),
                    markerColor: GoogleMarkerColor.violet,
                    mapType: MapType.normal,
                    style: GoogleMapStyle.standard,
                    initialZoom: 14.0,
                    allowInteraction: true,
                    allowZoom: true,
                    showZoomControls: true,
                    showLocation: true,
                    showCompass: false,
                    showMapToolbar: false,
                    showTraffic: false,
                    centerMapOnMarkerTap: true,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
                    child: Text(
                      'รูปภาพร้านค้า อัพโหลดได้หลายภาพ (ต้องมีอยางน้อย 1 รูป)',
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.00, 0.00),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 8.0, 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).accent3,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 10.0, 10.0, 10.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5.0, 0.0, 5.0, 0.0),
                                  child: Container(
                                    width: 100.0,
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5.0, 0.0, 5.0, 0.0),
                                  child: Container(
                                    width: 100.0,
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5.0, 0.0, 6.0, 0.0),
                                  child: Container(
                                    width: 100.0,
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5.0, 0.0, 5.0, 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 10.0, 10.0, 10.0),
                                      child: Icon(
                                        FFIcons.kpaperclipPlus,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        size: 30.0,
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'กำหนดที่อยูในการจัดส่ง ',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController7 ??=
                    FormFieldController<String>(null),
                options: ['ที่อยู่ 1', 'ที่อยู่ 2', 'ที่อยู่ 3'],
                onChanged: (val) => setState(() => _model.dropDownValue7 = val),
                height: 45.0,
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 0.0, 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'กำหนดที่อยูในการออกบิล',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController8 ??=
                    FormFieldController<String>(null),
                options: ['ที่อยู่ 1', 'ที่อยู่ 2', 'ที่อยู่ 3'],
                onChanged: (val) => setState(() => _model.dropDownValue8 = val),
                height: 45.0,
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController9 ??=
                    FormFieldController<String>(null),
                options: ['Dropdown  ๅ', 'Dropdown  2', 'Dropdown  3'],
                onChanged: (val) => setState(() => _model.dropDownValue9 = val),
                height: 45.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium,
                hintText:
                    'ถ้าเป็นที่อยูอื่นที่อยูในโปรไฟล์ลูกค้าให้เป็น Dropdown ให้เลือก ใน Dropdown แสดงรหัสสาขา',
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController10 ??=
                    FormFieldController<String>(null),
                options: ['Dropdown  ๅ', 'Dropdown  2', 'Dropdown  3'],
                onChanged: (val) =>
                    setState(() => _model.dropDownValue10 = val),
                height: 45.0,
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
                textAlign: TextAlign.start,
                validator:
                    _model.textController19Validator.asValidator(context),
              ),
            ),
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
                  hintText: 'สวนลดท้ายบิล (จำนวนบาท หรือ x%)',
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
                    _model.textController20Validator.asValidator(context),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController11 ??=
                    FormFieldController<String>(null),
                options: ['ประเภท  ๅ', 'ประเภท  2', 'ประเภท  3'],
                onChanged: (val) =>
                    setState(() => _model.dropDownValue11 = val),
                height: 45.0,
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
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController12 ??=
                    FormFieldController<String>(null),
                options: ['เงื่อนไข  ๅ', 'เงื่อนไข  2', 'เงื่อนไข  3'],
                onChanged: (val) =>
                    setState(() => _model.dropDownValue12 = val),
                height: 45.0,
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
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController13 ??=
                    FormFieldController<String>(null),
                options: ['ธนาคาร  ๅ', 'ธนาคาร  2', 'ธนาคาร  3'],
                onChanged: (val) =>
                    setState(() => _model.dropDownValue13 = val),
                height: 45.0,
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
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController14 ??=
                    FormFieldController<String>(null),
                options: ['แผนก  ๅ', 'แผนก  2', 'แผนก 3'],
                onChanged: (val) =>
                    setState(() => _model.dropDownValue14 = val),
                height: 45.0,
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
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController15 ??=
                    FormFieldController<String>(null),
                options: ['รหัสบัญชี   ๅ', 'รหัสบัญชี   2', 'รหัสบัญชี   3'],
                onChanged: (val) =>
                    setState(() => _model.dropDownValue15 = val),
                height: 45.0,
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
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController16 ??=
                    FormFieldController<String>(null),
                options: [
                  'รหัสพนักงาน  ๅ',
                  'รหัสพนักงาน  2',
                  'รหัสพนักงาน   3'
                ],
                onChanged: (val) =>
                    setState(() => _model.dropDownValue16 = val),
                height: 45.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium,
                hintText:
                    'รหัสพนักงานขาย (อ้างอิงจากรหัสพนักงานจากบัญชีผู้ใช้งานที่ Login เข้าระบบ)',
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController17 ??=
                    FormFieldController<String>(null),
                options: [
                  'ชื่อ-สกุล พนักงาน  ๅ',
                  'ชื่อ-สกุล พนักงาน  2',
                  'ชื่อ-สกุล พนักงาน  3'
                ],
                onChanged: (val) =>
                    setState(() => _model.dropDownValue17 = val),
                height: 45.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium,
                hintText:
                    'ชื่อ-สกุล พนักงานขาย (อ้างอิงจากชื่อผู้ใช้จากบัญชีผู้ใช้งานที่ Login เข้าระบบ)',
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController18 ??=
                    FormFieldController<String>(null),
                options: [
                  'กลุ่มลูกค้า  1  ',
                  'กลุ่มลูกค้า  2',
                  'กลุ่มลูกค้า  3'
                ],
                onChanged: (val) =>
                    setState(() => _model.dropDownValue18 = val),
                height: 45.0,
                textStyle: FlutterFlowTheme.of(context).bodyMedium,
                hintText:
                    'รหัสกลุ่มลูกค้า กลุม 1 - 5 (dropdown) / MFOOD API\' (Require กลุมลูกค้า 1 ต้องเลือกข้อมูล)',
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FlutterFlowDropDown<String>(
                controller: _model.dropDownValueController19 ??=
                    FormFieldController<String>(null),
                options: ['รหัสบัญชี   ๅ', 'รหัสบัญชี   2', 'รหัสบัญชี   3'],
                onChanged: (val) =>
                    setState(() => _model.dropDownValue19 = val),
                height: 45.0,
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
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'กรุณาแนบเอกสารดั่งต่อไปนี้',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Text(
                    '1) สําเนาบัตรประชาชน',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Text(
                    '2) ทะเบียนบ้าน (ไม่บังคับ)',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Text(
                    '3) แผ่นที่ในการจัดส่งสินค้า',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Text(
                    '4) เอกสารอื่นๆ ในกรณีที่ลูกค้าติดเครดิต',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.00, 0.00),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 5.0, 0.0, 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).accent3,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 10.0, 10.0, 10.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5.0, 0.0, 5.0, 0.0),
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 10.0, 0.0),
                                            child: Icon(
                                              FFIcons.kimagePlus,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 40.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5.0, 0.0, 5.0, 0.0),
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 10.0, 0.0),
                                            child: Icon(
                                              FFIcons.kimagePlus,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 40.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5.0, 0.0, 5.0, 0.0),
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 10.0, 0.0),
                                            child: Icon(
                                              FFIcons.kimagePlus,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              size: 40.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5.0, 0.0, 5.0, 0.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 10.0, 10.0, 10.0),
                                            child: Icon(
                                              FFIcons.kpaperclipPlus,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              size: 30.0,
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
            Align(
              alignment: AlignmentDirectional(0.00, 0.00),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: Container(
                            height: 400.0,
                            child: SignatureWidget(),
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'ลายเซ็น',
                  options: FFButtonOptions(
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
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FFButtonWidget(
                onPressed: () {
                  print('Button pressed ...');
                },
                text: 'แก้ไขข้อมูล',
                options: FFButtonOptions(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 40.0,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 5.0, 8.0, 5.0),
              child: FFButtonWidget(
                onPressed: () async {
                  context.pushNamed('A07_11_ListSave');
                },
                text: 'เซฟแล้วดำเนินการต่อไป',
                options: FFButtonOptions(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: 40.0,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
        ),
      ),
    );
  }
}
