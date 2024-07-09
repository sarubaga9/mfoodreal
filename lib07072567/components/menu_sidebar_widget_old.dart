import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'menu_sidebar_model.dart';
export 'menu_sidebar_model.dart';

class MenuSidebarWidgetOld extends StatefulWidget {
  const MenuSidebarWidgetOld({Key? key}) : super(key: key);

  @override
  _MenuSidebarWidgetOldState createState() => _MenuSidebarWidgetOldState();
}

class _MenuSidebarWidgetOldState extends State<MenuSidebarWidgetOld> {
  late MenuSidebarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuSidebarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).alternate,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      ' เมนูหลักในการทำงาน',
                      style: FlutterFlowTheme.of(context).titleMedium,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chevron_right_sharp,
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      size: 24.0,
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              thickness: 1.0,
              color: FlutterFlowTheme.of(context).accent4,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.kaccountCircle,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'แก้ไขจัดการโปรไฟล์',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.knotePlus,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'เปิดหน้าบัญชีลูกค้า',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    Icons.fact_check,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'ผลการอนุมัติเปิดบัญชี',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.kfolderAccount,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'บัญชีลูกค้าในระบบ',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.kaccountSearch,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'เช็คเครดิตลูกค้า',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.kfileDocumentPlus,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'เปิดใบสั่งขายสินค้า',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.knoteCheck,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'รายการอนุมัติสั่งขาย',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.ktruck,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'แผนการจัดส่งสินค้า',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.ktruckDelivery,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'สถานะการส่งสินค้า',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.kchartBox,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'รีพอร์ทการขาย',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.ktargetAccount,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'วางแผนเข้าเยี่ยมลูกค้า',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.kcalendarAccountOutline,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'ตารางแผนเข้าเยี่ยม',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.kcalendarClock,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'เก็บเวลาเข้าเยี่ยม',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.kclipboardTextClock,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'รีพอร์ทการเยี่ยมลูกค้า',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.kfileDocumentMultiple,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'แบบฟอร์มเอกสาร',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.kaccountEdit,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'เก็บข้อมูลลูกค้าใหม่',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.kaccountGroup,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'การจัดการทีมขาย',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.kfinance,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'รายงาน',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    FFIcons.kshieldAccountOutline,
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 40.0,
                  ),
                ),
                Text(
                  'จัดการ PDPA ในระบบ',
                  style: FlutterFlowTheme.of(context).bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
