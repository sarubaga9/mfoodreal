import '/components/appbarlogin_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'a0105_dashboard_widget.dart' show A0105DashboardWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class A0105DashboardModel extends FlutterFlowModel<A0105DashboardWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for Appbarlogin component.
  late AppbarloginModel appbarloginModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    appbarloginModel = createModel(context, () => AppbarloginModel());
  }

  void dispose() {
    unfocusNode.dispose();
    appbarloginModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
