import '/components/appbar_o_pen_widget.dart';
import '/components/form_general_user_edit_widget.dart';
import '/components/menu_sidebar_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'a0712_user_general_edit_widget.dart' show A0712UserGeneralEditWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class A0712UserGeneralEditModel
    extends FlutterFlowModel<A0712UserGeneralEditWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppbarOPen component.
  late AppbarOPenModel appbarOPenModel;
  // Model for MenuSidebar component.
  late MenuSidebarModel menuSidebarModel;
  // Model for FormGeneralUserEdit component.
  late FormGeneralUserEditModel formGeneralUserEditModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    appbarOPenModel = createModel(context, () => AppbarOPenModel());
    menuSidebarModel = createModel(context, () => MenuSidebarModel());
    formGeneralUserEditModel =
        createModel(context, () => FormGeneralUserEditModel());
  }

  void dispose() {
    unfocusNode.dispose();
    appbarOPenModel.dispose();
    menuSidebarModel.dispose();
    formGeneralUserEditModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
