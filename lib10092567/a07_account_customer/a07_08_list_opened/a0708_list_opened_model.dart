import '/components/appbar_o_pen_widget.dart';
import '/components/list_open_acoout_widget.dart';
import '../../components/menu_sidebar_widget_old.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'a0708_list_opened_widget.dart' show A0708ListOpenedWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class A0708ListOpenedModel extends FlutterFlowModel<A0708ListOpenedWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppbarOPen component.
  late AppbarOPenModel appbarOPenModel;
  // Model for MenuSidebar component.
  late MenuSidebarModel menuSidebarModel;
  // Model for ListOpenAcoout component.
  late ListOpenAcooutModel listOpenAcooutModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    appbarOPenModel = createModel(context, () => AppbarOPenModel());
    menuSidebarModel = createModel(context, () => MenuSidebarModel());
    listOpenAcooutModel = createModel(context, () => ListOpenAcooutModel());
  }

  void dispose() {
    unfocusNode.dispose();
    appbarOPenModel.dispose();
    menuSidebarModel.dispose();
    listOpenAcooutModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
