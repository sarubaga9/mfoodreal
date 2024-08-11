import 'package:m_food/a09_customer_open_sale/a0904_product_order_detail.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class A0904ProductOrderModel
    extends FlutterFlowModel<A0904ProductOrderDetail> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // Model for AppbarSummarize component.
  // late AppbarSummarizeModel appbarSummarizeModel;
  // State field(s) for CountController widget.
  int? countControllerValue1;
  // State field(s) for CountController widget.
  int? countControllerValue2;
  // State field(s) for CountController widget.
  int? countControllerValue3;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    // appbarSummarizeModel = createModel(context, () => AppbarSummarizeModel());
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    // appbarSummarizeModel.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
