import '/components/appbar_o_pen_widget.dart';
import '/components/form_legal_entity_copy_widget.dart';
import '/components/menu_sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'a0707_user_legal_entity_success_widget.dart'
    show A0707UserLegalEntitySuccessWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class A0707UserLegalEntitySuccessModel
    extends FlutterFlowModel<A0707UserLegalEntitySuccessWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppbarOPen component.
  late AppbarOPenModel appbarOPenModel;
  // Model for MenuSidebar component.
  late MenuSidebarModel menuSidebarModel;
  // Model for FormLegalEntityCopy component.
  late FormLegalEntityCopyModel formLegalEntityCopyModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    appbarOPenModel = createModel(context, () => AppbarOPenModel());
    menuSidebarModel = createModel(context, () => MenuSidebarModel());
    formLegalEntityCopyModel =
        createModel(context, () => FormLegalEntityCopyModel());
  }

  void dispose() {
    unfocusNode.dispose();
    appbarOPenModel.dispose();
    menuSidebarModel.dispose();
    formLegalEntityCopyModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
