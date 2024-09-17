import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_food/flutter_flow/flutter_flow_theme%20copy.dart';

class ScreenVersion extends StatefulWidget {
  const ScreenVersion({super.key});

  @override
  State<ScreenVersion> createState() => _ScreenVersionState();
}

class _ScreenVersionState extends State<ScreenVersion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: 400,
                height: 600,
                // color: Colors.red,
                child: Column(
                  children: [
                    Text(
                      'กรุณาอัพเดทเวอร์ชั่นแอพพลิเคชั่นค่ะ',
                      style: FlutterFlowTheme.of(context).headlineMedium,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Image.asset(
                              'assets/images/LINE_ALBUM__231114_1.jpg',
                              width: 60.0,
                              height: 60.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    //===================================================================
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'บริษัท มหาชัยฟู้ดส์ จํากัด',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Kanit',
                                    fontSize: 12.0,
                                  ),
                        ),
                      ],
                    ),
                    //===================================================================
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'MAHACHAI FOODS COMPANY LIMITED',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Kanit',
                                    fontSize: 12.0,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'เวอร์ชั่นแอพพลิเคชั่น 1.13',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Kanit',
                                    fontSize: 12.0,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    GestureDetector(
                      onTap: () {
                        SystemNavigator.pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.circular(40)),
                        padding: EdgeInsets.all(14),
                        child: Text(
                          'ปิดแอพพลิเคชั่น',
                          style: FlutterFlowTheme.of(context).headlineMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
