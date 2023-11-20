import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'list_open_acoout_copy_model.dart';
export 'list_open_acoout_copy_model.dart';

class ListOpenAcooutCopyWidget extends StatefulWidget {
  const ListOpenAcooutCopyWidget({Key? key}) : super(key: key);

  @override
  _ListOpenAcooutCopyWidgetState createState() =>
      _ListOpenAcooutCopyWidgetState();
}

class _ListOpenAcooutCopyWidgetState extends State<ListOpenAcooutCopyWidget> {
  late ListOpenAcooutCopyModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListOpenAcooutCopyModel());

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
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
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
                  hintText: 'ตรวจสอบชื่อว่ามีหน้าบัญชีในระบบอยู่แล้วหรือไม่',
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
            context.pushNamed('A07_12_UserGeneralEdit');
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'สุภาภร ครื้นจิต',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.chevron_right,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'วชิรวิทย์ แสนพระวัง',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.chevron_right,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
              ],
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
                  'แพรพลอย สินธุสาร',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.chevron_right,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
              ],
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
                  'เกศราภรณ์ ศรีสำราญ',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.chevron_right,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
              ],
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
                  'เมตตา โลกเชษฐ์ถาวร',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.chevron_right,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
              ],
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
                  'ชนิกานต์ อดุลยรัตนพันธุ์',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.chevron_right,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
