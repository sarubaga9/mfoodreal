import '/components/appbar_o_pen_widget.dart';
import '/components/form_legal_entity_widget.dart';
import '../../components/menu_sidebar_widget_old.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'a0706_user_legal_entity_widget.dart' show A0706UserLegalEntityWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class A0706UserLegalEntityModel
    extends FlutterFlowModel<A0706UserLegalEntityWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppbarOPen component.
  late AppbarOPenModel appbarOPenModel;
  // Model for MenuSidebar component.
  late MenuSidebarModel menuSidebarModel;
  // Model for FormLegalEntity component.
  late FormLegalEntityModel formLegalEntityModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    appbarOPenModel = createModel(context, () => AppbarOPenModel());
    menuSidebarModel = createModel(context, () => MenuSidebarModel());
    formLegalEntityModel = createModel(context, () => FormLegalEntityModel());
  }

  void dispose() {
    unfocusNode.dispose();
    appbarOPenModel.dispose();
    menuSidebarModel.dispose();
    formLegalEntityModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
