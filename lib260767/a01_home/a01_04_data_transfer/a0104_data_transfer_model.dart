import '/components/appbar_nologin_copy_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'a0104_data_transfer_widget.dart' show A0104DataTransferWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class A0104DataTransferModel extends FlutterFlowModel<A0104DataTransferWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppbarNologinCopy component.
  late AppbarNologinCopyModel appbarNologinCopyModel;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    appbarNologinCopyModel =
        createModel(context, () => AppbarNologinCopyModel());
  }

  void dispose() {
    unfocusNode.dispose();
    appbarNologinCopyModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
