import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'open_accout_model.dart';
export 'open_accout_model.dart';

class OpenAccoutWidget extends StatefulWidget {
  const OpenAccoutWidget({Key? key}) : super(key: key);

  @override
  _OpenAccoutWidgetState createState() => _OpenAccoutWidgetState();
}

class _OpenAccoutWidgetState extends State<OpenAccoutWidget> {
  late OpenAccoutModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OpenAccoutModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
          child: Container(
            height: 30.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).accent3,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
              child: TextFormField(
                controller: _model.textController,
                focusNode: _model.textFieldFocusNode,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  isDense: true,
                  labelStyle: FlutterFlowTheme.of(context).labelMedium,
                  hintText: 'ตรวจสอบชื่อวามีหน้าบัญชีในระบบอยูแล้วหรือไม่?',
                  hintStyle: FlutterFlowTheme.of(context).labelMedium,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.search,
                  ),
                ),
                style: FlutterFlowTheme.of(context).bodyMedium,
                textAlign: TextAlign.center,
                validator: _model.textControllerValidator.asValidator(context),
              ),
            ),
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            context.pushNamed('A07_02_OpenAccount');
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                child: Icon(
                  FFIcons.kfolderPlus,
                  color: FlutterFlowTheme.of(context).alternate,
                  size: 30.0,
                ),
              ),
              Text(
                'เปิดหน้าบัญชีใหม่เข้าสูระบบ',
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      fontFamily: 'Kanit',
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
              child: Icon(
                FFIcons.kfolderRefresh,
                color: FlutterFlowTheme.of(context).alternate,
                size: 30.0,
              ),
            ),
            Text(
              'ข้อมูลลูกค้าที่ยังทำไมครบทุกขั้นตอนที่เซฟเก็บไว้ทำภายหลัง',
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'Kanit',
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
            ),
          ],
        ),
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            context.pushNamed('A07_13_Accept');
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                        child: Icon(
                          FFIcons.kfolderCheck,
                          color: FlutterFlowTheme.of(context).alternate,
                          size: 30.0,
                        ),
                      ),
                      Text(
                        'ลูกค้าที่ผ่านการอนุมัติหน้าบัญชีแล้ว',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Kanit',
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).error,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                      child: Text(
                        '17',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Kanit',
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
              child: Icon(
                FFIcons.kfolderClock,
                color: FlutterFlowTheme.of(context).alternate,
                size: 30.0,
              ),
            ),
            Text(
              'รายการลูกค้าที่รออนุมัติการเปิดหน้าบัญชี',
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                      child: Icon(
                        FFIcons.kfolderCancel,
                        color: FlutterFlowTheme.of(context).alternate,
                        size: 30.0,
                      ),
                    ),
                    Text(
                      'ลูกค้าที่ไม่ผ่านการอนุมัติการเปิดบัญชี',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Kanit',
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).error,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                    child: Text(
                      '17',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Kanit',
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
