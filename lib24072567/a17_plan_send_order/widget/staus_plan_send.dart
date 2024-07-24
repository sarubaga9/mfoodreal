import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPlanSend extends StatefulWidget {
  final List<bool>? checkBool;
  final List<dynamic>? name;
  StatusPlanSend({
    super.key,
    this.checkBool,
    this.name,
  });

  @override
  _StatusPlanSendState createState() => _StatusPlanSendState();
}

class _StatusPlanSendState extends State<StatusPlanSend> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Step Approve');
    print(widget.checkBool);
    int number = 0;
    for (int i = 0; i < widget.checkBool!.length; i++) {
      if (widget.checkBool![i]) {
        number = number + 1;
      } else {}
    }
    print(number);

    print(widget.checkBool!.length);
    print(widget.name!.length);

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          // width: MediaQuery.sizeOf(context).width * 1.0,
          height: 90.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () async {
                    await scrollController.animateTo(
                      scrollController.position
                          .minScrollExtent, // ไปที่จุดสุดท้ายของ ScrollView
                      duration: const Duration(
                          milliseconds: 500), // ระยะเวลาในการ animate
                      curve: Curves.easeInOut, // ลักษณะการ animate
                    );
                  },
                  child: Icon(Icons.keyboard_double_arrow_left)),
              //=======================================================
              Container(
                width: MediaQuery.sizeOf(context).width * 0.9,
                child: SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < widget.checkBool!.length; i++)
                        i != (number - 1)
                            ? Container(
                                decoration: const BoxDecoration(),
                                child: Stack(
                                  alignment:
                                      const AlignmentDirectional(0.0, 0.0),
                                  children: [
                                    number == 0
                                        ? Positioned(
                                            bottom: 35,
                                            left: -8,
                                            child: Icon(
                                              FFIcons.kflagCheckered,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              size: 40.0,
                                            ),
                                          )
                                        : SizedBox(),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 5.0,
                                              child: VerticalDivider(
                                                width: 3.0,
                                                thickness: 3.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                              ),
                                            ),
                                          ].addToEnd(
                                              const SizedBox(width: 12.0)),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.00, 0.00),
                                                  child: Container(
                                                    width: 150.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 0.0,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          offset: const Offset(
                                                              10.0, -0.0),
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      border: Border.all(
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10.0,
                                              child: VerticalDivider(
                                                thickness: 3.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                              ),
                                            ),
                                          ].addToEnd(
                                              const SizedBox(width: 12.0)),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              widget.name![i].toString(),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ].addToStart(
                                          const SizedBox(height: 14.0)),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                decoration: const BoxDecoration(),
                                child: Stack(
                                  alignment:
                                      const AlignmentDirectional(0.0, 0.0),
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8.0, 0.0, 0.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Icon(
                                                FFIcons.kflagCheckered,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                size: 40.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0.00, 0.00),
                                                  child: Container(
                                                    width: 150.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 0.0,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          offset: const Offset(
                                                              10.0, -0.0),
                                                        )
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      border: Border.all(
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10.0,
                                              child: VerticalDivider(
                                                thickness: 3.0,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                              ),
                                            ),
                                          ].addToEnd(
                                              const SizedBox(width: 12.0)),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              widget.name![i].toString(),
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ].addToStart(
                                          const SizedBox(height: 14.0)),
                                    ),
                                  ],
                                ),
                              ),
                    ],
                  ),
                ),
              ),

              InkWell(
                  onTap: () async {
                    await scrollController.animateTo(
                      scrollController.position
                          .maxScrollExtent, // ไปที่จุดสุดท้ายของ ScrollView
                      duration: const Duration(
                          milliseconds: 500), // ระยะเวลาในการ animate
                      curve: Curves.easeInOut, // ลักษณะการ animate
                    );
                  },
                  child: Icon(Icons.keyboard_double_arrow_right)),

              //=======================================================
              //=======================================================
              // number != 2
              //     ? Container(
              //         decoration: const BoxDecoration(),
              //         child: Stack(
              //           alignment: const AlignmentDirectional(0.0, 0.0),
              //           children: [
              //             Column(
              //               mainAxisSize: MainAxisSize.max,
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: [
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   children: [
              //                     SizedBox(
              //                       height: 5.0,
              //                       child: VerticalDivider(
              //                         width: 3.0,
              //                         thickness: 3.0,
              //                         color: FlutterFlowTheme.of(context)
              //                             .secondaryText,
              //                       ),
              //                     ),
              //                   ].addToEnd(const SizedBox(width: 12.0)),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Column(
              //                       mainAxisSize: MainAxisSize.max,
              //                       children: [
              //                         Align(
              //                           alignment: const AlignmentDirectional(
              //                               0.00, 0.00),
              //                           child: Container(
              //                             width: 150.0,
              //                             decoration: BoxDecoration(
              //                               color: FlutterFlowTheme.of(context)
              //                                   .primaryText,
              //                               boxShadow: [
              //                                 BoxShadow(
              //                                   blurRadius: 0.0,
              //                                   color:
              //                                       FlutterFlowTheme.of(context)
              //                                           .primaryText,
              //                                   offset:
              //                                       const Offset(10.0, -0.0),
              //                                 )
              //                               ],
              //                               borderRadius:
              //                                   BorderRadius.circular(10.0),
              //                               border: Border.all(
              //                                 width: 2.0,
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.min,
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     SizedBox(
              //                       height: 10.0,
              //                       child: VerticalDivider(
              //                         thickness: 3.0,
              //                         color: FlutterFlowTheme.of(context)
              //                             .secondaryText,
              //                       ),
              //                     ),
              //                   ].addToEnd(const SizedBox(width: 12.0)),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Text(
              //                       'อนุมัติ 2',
              //                       style:
              //                           FlutterFlowTheme.of(context).bodyMedium,
              //                     ),
              //                   ],
              //                 ),
              //               ].addToStart(const SizedBox(height: 14.0)),
              //             ),
              //           ],
              //         ),
              //       )
              //     : Container(
              //         decoration: const BoxDecoration(),
              //         child: Stack(
              //           alignment: const AlignmentDirectional(0.0, 0.0),
              //           children: [
              //             Column(
              //               mainAxisSize: MainAxisSize.max,
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: [
              //                 Padding(
              //                   padding: const EdgeInsetsDirectional.fromSTEB(
              //                       8.0, 0.0, 0.0, 0.0),
              //                   child: Row(
              //                     mainAxisSize: MainAxisSize.max,
              //                     crossAxisAlignment: CrossAxisAlignment.end,
              //                     children: [
              //                       Icon(
              //                         FFIcons.kflagCheckered,
              //                         color: FlutterFlowTheme.of(context)
              //                             .primaryText,
              //                         size: 40.0,
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Column(
              //                       mainAxisSize: MainAxisSize.max,
              //                       children: [
              //                         Align(
              //                           alignment: const AlignmentDirectional(
              //                               0.00, 0.00),
              //                           child: Container(
              //                             width: 150.0,
              //                             decoration: BoxDecoration(
              //                               color: FlutterFlowTheme.of(context)
              //                                   .primaryText,
              //                               boxShadow: [
              //                                 BoxShadow(
              //                                   blurRadius: 0.0,
              //                                   color:
              //                                       FlutterFlowTheme.of(context)
              //                                           .primaryText,
              //                                   offset:
              //                                       const Offset(10.0, -0.0),
              //                                 )
              //                               ],
              //                               borderRadius:
              //                                   BorderRadius.circular(10.0),
              //                               border: Border.all(
              //                                 width: 2.0,
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.min,
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     SizedBox(
              //                       height: 10.0,
              //                       child: VerticalDivider(
              //                         thickness: 3.0,
              //                         color: FlutterFlowTheme.of(context)
              //                             .secondaryText,
              //                       ),
              //                     ),
              //                   ].addToEnd(const SizedBox(width: 12.0)),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Text(
              //                       'อนุมัติ 2',
              //                       style:
              //                           FlutterFlowTheme.of(context).bodyMedium,
              //                     ),
              //                   ],
              //                 ),
              //               ].addToStart(const SizedBox(height: 14.0)),
              //             ),
              //           ],
              //         ),
              //       ),
              // //=======================================================
              // number != 3
              //     ? Container(
              //         decoration: const BoxDecoration(),
              //         child: Stack(
              //           alignment: const AlignmentDirectional(0.0, 0.0),
              //           children: [
              //             Column(
              //               mainAxisSize: MainAxisSize.max,
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: [
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   children: [
              //                     SizedBox(
              //                       height: 5.0,
              //                       child: VerticalDivider(
              //                         width: 3.0,
              //                         thickness: 3.0,
              //                         color: FlutterFlowTheme.of(context)
              //                             .secondaryText,
              //                       ),
              //                     ),
              //                   ].addToEnd(const SizedBox(width: 12.0)),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Column(
              //                       mainAxisSize: MainAxisSize.max,
              //                       children: [
              //                         Align(
              //                           alignment: const AlignmentDirectional(
              //                               0.00, 0.00),
              //                           child: Container(
              //                             width: 150.0,
              //                             decoration: BoxDecoration(
              //                               color: FlutterFlowTheme.of(context)
              //                                   .primaryText,
              //                               boxShadow: [
              //                                 BoxShadow(
              //                                   blurRadius: 0.0,
              //                                   color:
              //                                       FlutterFlowTheme.of(context)
              //                                           .primaryText,
              //                                   offset:
              //                                       const Offset(10.0, -0.0),
              //                                 )
              //                               ],
              //                               borderRadius:
              //                                   BorderRadius.circular(10.0),
              //                               border: Border.all(
              //                                 width: 2.0,
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.min,
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     SizedBox(
              //                       height: 10.0,
              //                       child: VerticalDivider(
              //                         thickness: 3.0,
              //                         color: FlutterFlowTheme.of(context)
              //                             .secondaryText,
              //                       ),
              //                     ),
              //                   ].addToEnd(const SizedBox(width: 12.0)),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Text(
              //                       'อนุมัติ 3',
              //                       style:
              //                           FlutterFlowTheme.of(context).bodyMedium,
              //                     ),
              //                   ],
              //                 ),
              //               ].addToStart(const SizedBox(height: 14.0)),
              //             ),
              //           ],
              //         ),
              //       )
              //     : Container(
              //         decoration: const BoxDecoration(),
              //         child: Stack(
              //           alignment: const AlignmentDirectional(0.0, 0.0),
              //           children: [
              //             Column(
              //               mainAxisSize: MainAxisSize.max,
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: [
              //                 Padding(
              //                   padding: const EdgeInsetsDirectional.fromSTEB(
              //                       8.0, 0.0, 0.0, 0.0),
              //                   child: Row(
              //                     mainAxisSize: MainAxisSize.max,
              //                     crossAxisAlignment: CrossAxisAlignment.end,
              //                     children: [
              //                       Icon(
              //                         FFIcons.kflagCheckered,
              //                         color: FlutterFlowTheme.of(context)
              //                             .primaryText,
              //                         size: 40.0,
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Column(
              //                       mainAxisSize: MainAxisSize.max,
              //                       children: [
              //                         Align(
              //                           alignment: const AlignmentDirectional(
              //                               0.00, 0.00),
              //                           child: Container(
              //                             width: 150.0,
              //                             decoration: BoxDecoration(
              //                               color: FlutterFlowTheme.of(context)
              //                                   .primaryText,
              //                               boxShadow: [
              //                                 BoxShadow(
              //                                   blurRadius: 0.0,
              //                                   color:
              //                                       FlutterFlowTheme.of(context)
              //                                           .primaryText,
              //                                   offset:
              //                                       const Offset(10.0, -0.0),
              //                                 )
              //                               ],
              //                               borderRadius:
              //                                   BorderRadius.circular(10.0),
              //                               border: Border.all(
              //                                 width: 2.0,
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.min,
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     SizedBox(
              //                       height: 10.0,
              //                       child: VerticalDivider(
              //                         thickness: 3.0,
              //                         color: FlutterFlowTheme.of(context)
              //                             .secondaryText,
              //                       ),
              //                     ),
              //                   ].addToEnd(const SizedBox(width: 12.0)),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Text(
              //                       'อนุมัติ 3',
              //                       style:
              //                           FlutterFlowTheme.of(context).bodyMedium,
              //                     ),
              //                   ],
              //                 ),
              //               ].addToStart(const SizedBox(height: 14.0)),
              //             ),
              //           ],
              //         ),
              //       ),
              // //=======================================================
              // number != 4
              //     ? Container(
              //         decoration: const BoxDecoration(),
              //         child: Stack(
              //           alignment: const AlignmentDirectional(0.0, 0.0),
              //           children: [
              //             Column(
              //               mainAxisSize: MainAxisSize.max,
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: [
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   children: [
              //                     SizedBox(
              //                       height: 5.0,
              //                       child: VerticalDivider(
              //                         width: 3.0,
              //                         thickness: 3.0,
              //                         color: FlutterFlowTheme.of(context)
              //                             .secondaryText,
              //                       ),
              //                     ),
              //                   ].addToEnd(const SizedBox(width: 12.0)),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Column(
              //                       mainAxisSize: MainAxisSize.max,
              //                       children: [
              //                         Align(
              //                           alignment: const AlignmentDirectional(
              //                               0.00, 0.00),
              //                           child: Container(
              //                             width: 150.0,
              //                             decoration: BoxDecoration(
              //                               color: FlutterFlowTheme.of(context)
              //                                   .primaryText,
              //                               boxShadow: [
              //                                 BoxShadow(
              //                                   blurRadius: 0.0,
              //                                   color:
              //                                       FlutterFlowTheme.of(context)
              //                                           .primaryText,
              //                                   offset:
              //                                       const Offset(10.0, -0.0),
              //                                 )
              //                               ],
              //                               borderRadius:
              //                                   BorderRadius.circular(10.0),
              //                               border: Border.all(
              //                                 width: 2.0,
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.min,
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     SizedBox(
              //                       height: 10.0,
              //                       child: VerticalDivider(
              //                         thickness: 3.0,
              //                         color: FlutterFlowTheme.of(context)
              //                             .secondaryText,
              //                       ),
              //                     ),
              //                   ].addToEnd(const SizedBox(width: 12.0)),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Text(
              //                       'อนุมัติ 4',
              //                       style:
              //                           FlutterFlowTheme.of(context).bodyMedium,
              //                     ),
              //                   ],
              //                 ),
              //               ].addToStart(const SizedBox(height: 14.0)),
              //             ),
              //           ],
              //         ),
              //       )
              //     : Container(
              //         decoration: const BoxDecoration(),
              //         child: Stack(
              //           alignment: const AlignmentDirectional(0.0, 0.0),
              //           children: [
              //             Column(
              //               mainAxisSize: MainAxisSize.max,
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: [
              //                 Padding(
              //                   padding: const EdgeInsetsDirectional.fromSTEB(
              //                       8.0, 0.0, 0.0, 0.0),
              //                   child: Row(
              //                     mainAxisSize: MainAxisSize.max,
              //                     crossAxisAlignment: CrossAxisAlignment.end,
              //                     children: [
              //                       Icon(
              //                         FFIcons.kflagCheckered,
              //                         color: FlutterFlowTheme.of(context)
              //                             .primaryText,
              //                         size: 40.0,
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Column(
              //                       mainAxisSize: MainAxisSize.max,
              //                       children: [
              //                         Align(
              //                           alignment: const AlignmentDirectional(
              //                               0.00, 0.00),
              //                           child: Container(
              //                             width: 150.0,
              //                             decoration: BoxDecoration(
              //                               color: FlutterFlowTheme.of(context)
              //                                   .primaryText,
              //                               boxShadow: [
              //                                 BoxShadow(
              //                                   blurRadius: 0.0,
              //                                   color:
              //                                       FlutterFlowTheme.of(context)
              //                                           .primaryText,
              //                                   offset:
              //                                       const Offset(10.0, -0.0),
              //                                 )
              //                               ],
              //                               borderRadius:
              //                                   BorderRadius.circular(10.0),
              //                               border: Border.all(
              //                                 width: 2.0,
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.min,
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     SizedBox(
              //                       height: 10.0,
              //                       child: VerticalDivider(
              //                         thickness: 3.0,
              //                         color: FlutterFlowTheme.of(context)
              //                             .secondaryText,
              //                       ),
              //                     ),
              //                   ].addToEnd(const SizedBox(width: 12.0)),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Text(
              //                       'อนุมัติ 4',
              //                       style:
              //                           FlutterFlowTheme.of(context).bodyMedium,
              //                     ),
              //                   ],
              //                 ),
              //               ].addToStart(const SizedBox(height: 14.0)),
              //             ),
              //           ],
              //         ),
              //       ),
              // //=======================================================
              // number != 5
              //     ? Container(
              //         decoration: const BoxDecoration(),
              //         child: Stack(
              //           alignment: const AlignmentDirectional(0.0, 0.0),
              //           children: [
              //             Column(
              //               mainAxisSize: MainAxisSize.max,
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: [
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   children: [
              //                     SizedBox(
              //                       height: 5.0,
              //                       child: VerticalDivider(
              //                         width: 3.0,
              //                         thickness: 3.0,
              //                         color: FlutterFlowTheme.of(context)
              //                             .secondaryText,
              //                       ),
              //                     ),
              //                   ].addToEnd(const SizedBox(width: 12.0)),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Column(
              //                       mainAxisSize: MainAxisSize.max,
              //                       children: [
              //                         Align(
              //                           alignment: const AlignmentDirectional(
              //                               0.00, 0.00),
              //                           child: Container(
              //                             width: 150.0,
              //                             decoration: BoxDecoration(
              //                               color: FlutterFlowTheme.of(context)
              //                                   .primaryText,
              //                               boxShadow: [
              //                                 BoxShadow(
              //                                   blurRadius: 0.0,
              //                                   color:
              //                                       FlutterFlowTheme.of(context)
              //                                           .primaryText,
              //                                   offset:
              //                                       const Offset(10.0, -0.0),
              //                                 )
              //                               ],
              //                               borderRadius:
              //                                   BorderRadius.circular(10.0),
              //                               border: Border.all(
              //                                 width: 2.0,
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.min,
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     SizedBox(
              //                       height: 10.0,
              //                       child: VerticalDivider(
              //                         thickness: 3.0,
              //                         color: FlutterFlowTheme.of(context)
              //                             .secondaryText,
              //                       ),
              //                     ),
              //                   ].addToEnd(const SizedBox(width: 12.0)),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Text(
              //                       'อนุมัติ 5',
              //                       style:
              //                           FlutterFlowTheme.of(context).bodyMedium,
              //                     ),
              //                   ],
              //                 ),
              //               ].addToStart(const SizedBox(height: 14.0)),
              //             ),
              //           ],
              //         ),
              //       )
              //     : Container(
              //         decoration: const BoxDecoration(),
              //         child: Stack(
              //           alignment: const AlignmentDirectional(0.0, 0.0),
              //           children: [
              //             Column(
              //               mainAxisSize: MainAxisSize.max,
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: [
              //                 Padding(
              //                   padding: const EdgeInsetsDirectional.fromSTEB(
              //                       8.0, 0.0, 0.0, 0.0),
              //                   child: Row(
              //                     mainAxisSize: MainAxisSize.max,
              //                     crossAxisAlignment: CrossAxisAlignment.end,
              //                     children: [
              //                       Icon(
              //                         FFIcons.kflagCheckered,
              //                         color: FlutterFlowTheme.of(context)
              //                             .primaryText,
              //                         size: 40.0,
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Column(
              //                       mainAxisSize: MainAxisSize.max,
              //                       children: [
              //                         Align(
              //                           alignment: const AlignmentDirectional(
              //                               0.00, 0.00),
              //                           child: Container(
              //                             width: 150.0,
              //                             decoration: BoxDecoration(
              //                               color: FlutterFlowTheme.of(context)
              //                                   .primaryText,
              //                               boxShadow: [
              //                                 BoxShadow(
              //                                   blurRadius: 0.0,
              //                                   color:
              //                                       FlutterFlowTheme.of(context)
              //                                           .primaryText,
              //                                   offset:
              //                                       const Offset(10.0, -0.0),
              //                                 )
              //                               ],
              //                               borderRadius:
              //                                   BorderRadius.circular(10.0),
              //                               border: Border.all(
              //                                 width: 2.0,
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.min,
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     SizedBox(
              //                       height: 10.0,
              //                       child: VerticalDivider(
              //                         thickness: 3.0,
              //                         color: FlutterFlowTheme.of(context)
              //                             .secondaryText,
              //                       ),
              //                     ),
              //                   ].addToEnd(const SizedBox(width: 12.0)),
              //                 ),
              //                 Row(
              //                   mainAxisSize: MainAxisSize.max,
              //                   children: [
              //                     Text(
              //                       'อนุมัติ 5',
              //                       style:
              //                           FlutterFlowTheme.of(context).bodyMedium,
              //                     ),
              //                   ],
              //                 ),
              //               ].addToStart(const SizedBox(height: 14.0)),
              //             ),
              //           ],
              //         ),
              //       ),
            ],
          ),
        ),
      ],
    );
  }
}
