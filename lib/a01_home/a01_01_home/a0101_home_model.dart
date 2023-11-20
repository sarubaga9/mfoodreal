import '/components/appbar_search_widget.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'a0101_home_widget.dart' show A0101HomeWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class A0101HomeModel extends FlutterFlowModel<A0101HomeWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppbarSearch component.
  late AppbarSearchModel appbarSearchModel;
  // State field(s) for CountController widget.
  int? countControllerValue1;
  // State field(s) for CountController widget.
  int? countControllerValue2;
  // State field(s) for CountController widget.
  int? countControllerValue3;
  // State field(s) for CountController widget.
  int? countControllerValue4;
  // State field(s) for CountController widget.
  int? countControllerValue5;
  // State field(s) for CountController widget.
  int? countControllerValue6;
  // State field(s) for CountController widget.
  int? countControllerValue7;
  // State field(s) for CountController widget.
  int? countControllerValue8;
  // State field(s) for CountController widget.
  int? countControllerValue9;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    appbarSearchModel = createModel(context, () => AppbarSearchModel());
  }

  void dispose() {
    unfocusNode.dispose();
    appbarSearchModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
