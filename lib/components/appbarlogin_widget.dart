import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:m_food/controller/shared_preference_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'appbarlogin_model.dart';
export 'appbarlogin_model.dart';

class AppbarloginWidget extends StatefulWidget {
  const AppbarloginWidget({Key? key}) : super(key: key);

  @override
  _AppbarloginWidgetState createState() => _AppbarloginWidgetState();
}

class _AppbarloginWidgetState extends State<AppbarloginWidget> {
  late AppbarloginModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppbarloginModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  } //============================================================================

  String message = '';
  final SharedPreferenceController myController = SharedPreferenceController();
  bool isLoadingLogout = false;

  Future<void> saveDataToSharedPreferences(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    // print(value);
  }

  Future<void> saveData(String userId) async {
    await saveDataToSharedPreferences('message_key', userId);
    // print('Data saved.');
  }

  void saveDataForLogout() async {
    try {
      final userController = Get.find<UserController>();
      setState(() {
        isLoadingLogout = true;
      });

      await FirebaseFirestore.instance
          .collection('User')
          .doc(userController.userData!['UserID'])
          .update(
        {
          'UserTokenID': '',
        },
      ).then((value) async {
        final test =
            FirebaseFirestore.instance.collection('User').doc('NoUser').get();
        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await test;
        if (documentSnapshot.exists) {
          final data = documentSnapshot.data();
        } else {
          print('ไม่พบข้อมูลสำหรับเอกสารนี้');
        }
        print('documentdatalogout');
        print(documentSnapshot.data());
        print('savedata');
        await saveData('');
        print('updatestring');
        await myController.updateString('');
        print('updateuser');
        await userController.updateUserDataPhone(documentSnapshot);
        print('logout');
        await Future.delayed(Duration(seconds: 3));
        // .then((value) => context.push('A011_Home'));
      });
    } catch (error) {
      print('error profile_screen.dart -> ${error}');
    } finally {
      if (mounted) {
        setState(() {
          isLoadingLogout = false;
        });
      }
      // runApp(A011HomeWidget());
      Navigator.pop(context);
      // context.push('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          Navigator.pop(context);
                          context.safePop();
                        },
                        child: Icon(
                          Icons.chevron_left,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed('A01_01_Home');
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.asset(
                            'assets/images/LINE_ALBUM__231114_1.jpg',
                            width: 40.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'มหาชัยฟู้ดส์ จํากัด',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Kanit',
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'แดชบอร์ด',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Kanit',
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'สมัครสมาชิกที่นี่',
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                fontFamily: 'Kanit',
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'ล็อกอินเข้าสู่ระบบ',
                          style: FlutterFlowTheme.of(context).bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          // context.pushNamed('A01_05_Dashboard');
                          saveDataForLogout();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.asset(
                            'assets/images/31047129_m.jpg',
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
