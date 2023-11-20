import '/components/appbar_o_pen_widget.dart';
import '/components/menu_sidebar_widget.dart';
import '/components/open_accout_copy_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'a0705_open_account_copy_widget.dart' show A0705OpenAccountCopyWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class A0705OpenAccountCopyModel
    extends FlutterFlowModel<A0705OpenAccountCopyWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppbarOPen component.
  late AppbarOPenModel appbarOPenModel;
  // Model for MenuSidebar component.
  late MenuSidebarModel menuSidebarModel;
  // Model for OpenAccoutCopy component.
  late OpenAccoutCopyModel openAccoutCopyModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    appbarOPenModel = createModel(context, () => AppbarOPenModel());
    menuSidebarModel = createModel(context, () => MenuSidebarModel());
    openAccoutCopyModel = createModel(context, () => OpenAccoutCopyModel());
  }

  void dispose() {
    unfocusNode.dispose();
    appbarOPenModel.dispose();
    menuSidebarModel.dispose();
    openAccoutCopyModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
