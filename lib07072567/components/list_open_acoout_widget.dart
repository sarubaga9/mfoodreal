import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'list_open_acoout_model.dart';
export 'list_open_acoout_model.dart';

class ListOpenAcooutWidget extends StatefulWidget {
  const ListOpenAcooutWidget({Key? key}) : super(key: key);

  @override
  _ListOpenAcooutWidgetState createState() => _ListOpenAcooutWidgetState();
}

class _ListOpenAcooutWidgetState extends State<ListOpenAcooutWidget> {
  late ListOpenAcooutModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListOpenAcooutModel());

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
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
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
                  hintText: 'ค้นหารายชื่อเพื่อดูสถานะการอนุมัติการดำเนินการ',
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
            context.pushNamed('A07_09_step');
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    '09 ตค 2566 ญญรัชต์ สาระชาติ',
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'ผู้บริหารอนุมัติแล้ว 0 ท่าน',
                    style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 วชิรวิทย์ แสนพระวัง',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 0 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 เกศราภรณ์ ศรีสำราญ',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 0 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566  กฤตวัฒน์ สุวานิชย์',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 4 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 อรณิชา ลิมปธนโชต',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 4 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 เมตตา โลกเชษฐ์ถาวร',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 4 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566  จรัญญา เลิศสินไพศาล',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 3 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 ชนิกานต์ อดุลยรัตนพันธ',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 3 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 วรานิษฐ์ ศิริพรอมาตย์',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 3 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566  ปณภัช วรชนะนันท์',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 3 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 ณัฐนิชา พงศ์ธีรการ',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 2 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 รุจิรัตน ศิริวัฒนานุกูล',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 2 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 วิจิตร์ ล้ำศิริเจริญโชค',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 1 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 ธนาภา ธนกิจวาณิชกุล',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 1 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 เจตธิดา หลอลักษณ',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 1 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 นายวิษณุ เกิดสินธิชัย',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 1 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 จุฑามาศ อรพินท์พิศุทธิ์ ',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 1 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
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
                  '09 ตค 2566 ธันยรัศมิ์ ชอเพ็ชรไทย',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'ผู้บริหารอนุมัติแล้ว 1 ท่าน',
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
