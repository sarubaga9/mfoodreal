import '/components/appbar_o_pen_widget.dart';
import '/components/menu_sidebar_widget.dart';
import '/components/open_accout_for_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'a0702_open_account_widget.dart' show A0702OpenAccountWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class A0702OpenAccountModel extends FlutterFlowModel<A0702OpenAccountWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppbarOPen component.
  late AppbarOPenModel appbarOPenModel;
  // Model for MenuSidebar component.
  late MenuSidebarModel menuSidebarModel;
  // Model for OpenAccoutFor component.
  late OpenAccoutForModel openAccoutForModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    appbarOPenModel = createModel(context, () => AppbarOPenModel());
    menuSidebarModel = createModel(context, () => MenuSidebarModel());
    openAccoutForModel = createModel(context, () => OpenAccoutForModel());
  }

  void dispose() {
    unfocusNode.dispose();
    appbarOPenModel.dispose();
    menuSidebarModel.dispose();
    openAccoutForModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
