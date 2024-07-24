import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:m_food/a01_home/a01_05_dashboard/pages/a010500_news_list.dart';
import 'package:m_food/a01_home/a01_05_dashboard/pages/a010501_news_detail.dart';
import 'package:m_food/a01_home/a01_05_dashboard/pages/a010502_sale_list.dart';
import 'package:m_food/a07_account_customer/a07_01_open_account/a0701_open_account_widget.dart';
import 'package:m_food/a08_customer_rating_group/a0801_customer_rating_group.dart';
import 'package:m_food/a09_customer_open_sale/a0900_choose_page.dart';
import 'package:m_food/a09_customer_open_sale/a0901_customer_list.dart';
import 'package:m_food/a10_customer_credit/a1001_customer_credit_list.dart';
import 'package:m_food/a11_edit_user_profile/a1101_edit_user_profile.dart';
import 'package:m_food/a12_add_new_customer/a1201_add_new_customer.dart';
import 'package:m_food/a13_visit_customer_plan/a1301_visit_list.dart';
import 'package:m_food/a14_visit_save_time/a1401_visit_save_time.dart';
import 'package:m_food/a15_report_check_in/a1501_report_check_in.dart';
import 'package:m_food/a16_wait_order/a1600_customer_choose.dart';
import 'package:m_food/a16_wait_order/a1601_customer_wait_order.dart';
import 'package:m_food/a16_wait_order/a1601_customer_wait_order_menu.dart';
import 'package:m_food/a17_plan_send_order/a1701_plan_send.dart';
import 'package:m_food/a20_add_new_customer_first/a2001_add_new_customer_first.dart';
import 'package:m_food/a21_version/a2101_version.dart';
import 'package:m_food/a22_pdpa_customer/a2201_customer_pdpa_list.dart';
import 'package:m_food/a23_sale_setting/a2300_choose_setting.dart';
import 'package:m_food/a23_sale_setting/a2301_sale_setting.dart';
import 'package:m_food/a24_report/a2400_choose_report.dart';
import 'package:m_food/components/pie_chart.dart';
import 'package:m_food/controller/shared_preference_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/index.dart';
import 'package:m_food/main.dart';
import 'package:m_food/model/TeamGoal.dart';
import 'package:m_food/widgets/circular_loading_home.dart';
import 'package:m_food/widgets/data_transfer_widget.dart';
import 'package:m_food/widgets/data_transfer_widget_no_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/components/appbarlogin_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'a0105_dashboard_model.dart';
export 'a0105_dashboard_model.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

class A0105DashboardWidget extends StatefulWidget {
  const A0105DashboardWidget({Key? key}) : super(key: key);

  @override
  _A0105DashboardWidgetState createState() => _A0105DashboardWidgetState();
}

class _A0105DashboardWidgetState extends State<A0105DashboardWidget> {
  bool isLoadingLogout = false;
  bool isLoading = false;
  bool isLoadingData = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userController = Get.find<UserController>();
  RxMap<String, dynamic>? userData;
  List<Map<String, dynamic>?>? orderList = [];

  List<List<Map<String, dynamic>>> monthlyOrders = [];
  List<String>? totalOrderList = [];
  List<String>? beforeSixMonths = [];
  double totalMonthCheck = 0.0;
  int percentageShow = 0;

  double totalMonth = 0.0;

  List<Map<String, dynamic>?>? visitList = [];
  List<Map<String, dynamic>?>? visitBeforeList = [];

  List<Map<String, dynamic>> tempList = [];
  List<Map<String, dynamic>> newsList = [];
  List<Map<String, dynamic>> newsListLength = [];

  List<List<Map<String, dynamic>>> groupedOrderList = [];

  List<double> topSaleTotal = [];
  List<String> topSaleName = [];
  List<String> topSaleID = [];
  List<String?> topSaleImg = [];

  List<SalesData> data = [];

  // ฟังก์ชันแปลง String เป็น DateTime
  DateTime parseDate(String date) {
    return DateTime.parse(date);
  }

  // ฟังก์ชันกรองรายการภายในช่วงเวลา 6 เดือนย้อนหลัง
  List<List<Map<String, dynamic>>> filterOrdersByMonth(
      List<Map<String, dynamic>?>? orders) {
    List<List<Map<String, dynamic>>> monthlyOrders =
        List.generate(6, (_) => []);

    // วันที่ปัจจุบัน
    DateTime now = DateTime.now();

    for (var order in orders!) {
      DateTime orderDate =
          parseDate(order!['OrdersUpdateTime'].toDate().toString());
      int monthDifference =
          now.month - orderDate.month + (now.year - orderDate.year) * 12;

      if (monthDifference >= 0 && monthDifference < 6) {
        monthlyOrders[monthDifference].add(order);
      }
    }

    return monthlyOrders;
  }

  void fetchData() async {
    try {
      setState(() {
        isLoadingData = true;
      });
      userData = userController.userData;

      await initializeDateFormatting('th_TH', null);

      print(userData!['เป้าหมายประจำเดือน']);

      //---------------------- คำนวนอดขาย 6 เดือนหลัง --------------------------------

      QuerySnapshot orderSubCollections = await FirebaseFirestore.instance
          .collection(AppSettings.customerType == CustomerType.Test
              ? 'OrdersTest_benz040767'
              : 'Orders')
          .where('UserDocId', isEqualTo: userData!['EmployeeID'])
          .get();
      // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
      orderSubCollections.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        orderList!.add(data);

        print(data['OrdersUpdateTime'].toDate());
      });

      print(orderList!.length);

      // กรองข้อมูล
      monthlyOrders = filterOrdersByMonth(orderList!);

      for (int i = 0; i < monthlyOrders.length; i++) {
        double total = 0;

        for (int j = 0; j < monthlyOrders[i].length; j++) {
          // print(monthlyOrders[i][j]['OrdersUpdateTime'].toDate());
          total = total +
              double.parse(monthlyOrders[i][j]['มูลค่าสินค้ารวม'].toString());
        }
        print(total.toString());

        if (i == 0) {
          totalMonth = total;
        }

        totalOrderList!.add(NumberFormat('#,##0').format(total));

        if (totalOrderList!.length == 1) {
          totalMonthCheck = total;
        }

        // print(NumberFormat('#,##0').format(totalOrderList!.last));
      }
      double totalFlag =
          double.parse(userData!['เป้าหมายประจำเดือน'].toString());

      double totalMonthPercent = totalMonthCheck;

      double percentageDouble = (totalMonthPercent / totalFlag) * 100;

      int percentage = percentageDouble.round();
      percentageShow = percentage;

      data = [
        SalesData('now', percentage > 100 ? 100 : percentage),
        SalesData('before', percentage > 100 ? 0 : 100 - percentage),
      ];

      //---------------------- คำนวนเดือน 6 เดือนหลัง --------------------------------

      DateTime now = DateTime.now();

      for (int i = 0; i < 6; i++) {
        DateTime beforeMonth = DateTime(now.year, now.month - i, 1);
        String monthName = DateFormat('MMMM yyyy', 'th_TH').format(beforeMonth);

        // แปลงปีเป็นพุทธศักราช (ปีพุทธศักราช = ปีคริสต์ศักราช + 543)
        int buddhistYear = beforeMonth.year + 543;
        String monthYearBuddhist = monthName.replaceAll(
            beforeMonth.year.toString(), buddhistYear.toString());

        beforeSixMonths!.add(monthYearBuddhist);
      }

      print('before 6 months: $beforeSixMonths');

      //---------------------- แผนเข้าพบลูกค้า เดือนหลัง --------------------------------

      QuerySnapshot visitSubCollections = await FirebaseFirestore.instance
          .collection('เข้าเยี่ยมลูกค้า')
          .where('UserID', isEqualTo: userData!['EmployeeID'])
          .get();
      // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
      visitSubCollections.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        Timestamp timestamp = data['วันเดือนปีนัดหมาย'];
        DateTime date = timestamp.toDate();
        if (date.isAfter(now)) {
          visitList!.add(data);
        }

        if (date.isBefore(now)) {
          visitBeforeList!.add(data);
        }
      });

      // จัดเรียง visitList ตามฟิลด์เวลา (จากใหม่ไปเก่า)
      visitList!.sort((b, a) {
        Timestamp aTimestamp = a!['วันเดือนปีนัดหมาย'];
        Timestamp bTimestamp = b!['วันเดือนปีนัดหมาย'];
        return bTimestamp.compareTo(aTimestamp); // เปรียบเทียบจากใหม่ไปเก่า
      });

      visitBeforeList!.sort((b, a) {
        Timestamp aTimestamp = a!['วันเดือนปีนัดหมาย'];
        Timestamp bTimestamp = b!['วันเดือนปีนัดหมาย'];
        return aTimestamp.compareTo(bTimestamp); // เปรียบเทียบจากใหม่ไปเก่า
      });

      if (visitList!.length < 5) {
        for (int i = visitList!.length; i < 5; i++) {
          visitList!.add({
            'วันเดือนปีนัดหมาย': null,
            'ชื่อนามสกุล': '',
          });
        }
      }

      if (visitBeforeList!.length < 5) {
        for (int i = visitBeforeList!.length; i < 5; i++) {
          visitBeforeList!.add({
            'วันเดือนปีนัดหมาย': null,
            'ชื่อนามสกุล': '',
          });
        }
      }
      // //---------------------- ออเดอร์ยอดขายพนักงานทั้งหมด เดือนปัจจุบัน --------------------------------

      // DateTime nowTime = DateTime.now();
      // DateTime startOfMonth = DateTime(nowTime.year, nowTime.month, 1);
      // DateTime startOfNextMonth = DateTime(nowTime.year, nowTime.month + 1, 1);

      // QuerySnapshot orderAllSubCollections = await FirebaseFirestore.instance
      //     .collection(AppSettings.customerType == CustomerType.Test
      //         ? 'OrdersTest_benz040767'
      //         : 'Orders')
      //     .where('OrdersUpdateTime', isGreaterThanOrEqualTo: startOfMonth)
      //     .where('OrdersUpdateTime', isLessThan: startOfNextMonth)
      //     .get();

      // // orderAllSubCollections.docs.forEach((doc) {
      // //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // //   tempList.add(data);
      // // });

      // // tempList.sort((a, b) {
      // //   Timestamp aTimestamp = a['OrdersUpdateTime'];
      // //   Timestamp bTimestamp = b['OrdersUpdateTime'];
      // //   return bTimestamp.compareTo(aTimestamp);
      // // });

      // // for (var element in tempList) {
      // //   print(element['OrdersUpdateTime'].toDate());
      // //   print(element['UserDocId']);
      // //   print(element['มูลค่าสินค้ารวม']);
      // // }

      // Map<String, List<Map<String, dynamic>>> tempMap = {};

      // orderAllSubCollections.docs.forEach((doc) {
      //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      //   String id = data['UserDocId'];

      //   if (!tempMap.containsKey(id)) {
      //     tempMap[id] = [];
      //   }
      //   tempMap[id]!.add(data);
      // });

      // List<List<Map<String, dynamic>>> tempList = tempMap.values.toList();
      // groupedOrderList = tempList;

      // for (int i = 0; i < groupedOrderList.length; i++) {
      //   print(groupedOrderList[i].length);
      //   double total = 0.0;
      //   for (int j = 0; j < groupedOrderList[i].length; j++) {
      //     if (j == 0) {
      //       topSaleID.add(groupedOrderList[i][0]['UserDocId']);
      //     }
      //     total = total +
      //         double.parse(
      //             groupedOrderList[i][j]['มูลค่าสินค้ารวม'].toString());
      //   }

      //   topSaleTotal.add(total);
      // }

      // List<Map<String, dynamic>?>? user = [];

      // for (int i = 0; i < topSaleID.length; i++) {
      //   QuerySnapshot findUser = await FirebaseFirestore.instance
      //       .collection('User')
      //       .where('EmployeeID', isEqualTo: topSaleID[i])
      //       .get();
      //   // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
      //   findUser.docs.forEach((doc) {
      //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      //     user.add(data);
      //   });
      // }

      // for (int i = 0; i < user.length; i++) {
      //   topSaleName.add('${user[i]!['Name']} ${user[i]!['Surname']}');
      //   topSaleImg.add(user[i]!['Img']);
      //   print(topSaleTotal[i]);
      //   print(topSaleName.last);
      //   print(topSaleImg.last);
      // }

      // List<Map<String, dynamic>> combinedList = [];
      // for (int i = 0; i < topSaleTotal.length; i++) {
      //   combinedList.add({'total': topSaleTotal[i], 'name': topSaleName[i]});
      // }

      // combinedList.sort((a, b) => b['total'].compareTo(a['total']));

      // topSaleTotal =
      //     combinedList.map((item) => item['total'] as double).toList();
      // topSaleName = combinedList.map((item) => item['name'] as String).toList();

      // print(topSaleTotal);
      // print(topSaleName);

      // if (topSaleTotal!.length < 4) {
      //   for (int i = topSaleTotal!.length; i < 4; i++) {
      //     topSaleTotal!.add(0);
      //     topSaleName.add('');
      //     topSaleImg.add(null);
      //   }
      // }

      //---------------------- ข่าวสาร --------------------------------

      QuerySnapshot news =
          await FirebaseFirestore.instance.collection('ข่าวสาร').get();
      // วนลูปเพื่อดึงข้อมูลจาก documents ใน subcollection 'นพกำพห'
      news.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        newsList.add(data);
        newsListLength.add(data);
      });

      // จัดเรียง visitList ตามฟิลด์เวลา (จากใหม่ไปเก่า)
      newsList!.sort((a, b) {
        Timestamp aTimestamp = a!['วันที่อัพเดท'];
        Timestamp bTimestamp = b!['วันที่อัพเดท'];
        return bTimestamp.compareTo(aTimestamp); // เปรียบเทียบจากใหม่ไปเก่า
      });

      if (newsList!.length < 7) {
        for (int i = newsList!.length; i < 7; i++) {
          newsList!.add({
            'หัวข้อ': '',
            'วันที่อัพเดท': null,
          });
        }
      }

      if (mounted) {
        setState(() {
          isLoadingData = false;
        });
      }
    } catch (e) {
      print('เกิดข้อผิดพลาด: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String message = '';
  final SharedPreferenceController myController = SharedPreferenceController();

  Future<void> saveDataToSharedPreferences(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    // print(value);
  }

  Future<void> saveData(String userId) async {
    await saveDataToSharedPreferences('message_key', userId);
    // print('Data saved.');
  }

  Future<void> saveDataForLogout() async {
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
    Widget renderChart(
        {id = 'sale',
        color = const [Colors.grey, Colors.blue],
        legend = const ['เงินสด', 'เครดิต'],
        total = const [50, 50]}) {
      final data = [
        TeamGoal(charts.ColorUtil.fromDartColor(color[0]), legend[0], total[0]),
        TeamGoal(charts.ColorUtil.fromDartColor(color[1]), legend[1], total[1]),
      ];
      int sum = total[0] + total[1];
      if (sum == 0) {
        List<charts.Series<TeamGoal, String>> series = [
          charts.Series(
            id: id,
            data: data,
            domainFn: (TeamGoal sale, _) => sale.text,
            measureFn: (TeamGoal sale, _) => 50,
            colorFn: (TeamGoal sale, _) => sale.color,
          )
        ];
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CeoPieChart(
            series,
            animate: true,
            enableLabel: true,
            horizontalFirst: true,
          ),
        );
      } else {
        //print('cas sum not 0 : $sum');
        List<charts.Series<TeamGoal, String>> series = [
          charts.Series(
            id: id,
            data: data,
            domainFn: (TeamGoal sale, _) => sale.text,
            measureFn: (TeamGoal sale, _) => sale.total,
            colorFn: (TeamGoal sale, _) => sale.color,
            labelAccessorFn: (TeamGoal sale, _) =>
                '${(sale.total / sum * 100).round()} %',
          )
        ];
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CeoPieChart(
            series,
            animate: true,
            enableLabel: true,
            horizontalFirst: true,
          ),
        );
      }
    }

    String formatThaiDate(Timestamp timestamp) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        timestamp.seconds * 1000 + (timestamp.nanoseconds / 1000000).round(),
      );

      // แปลงปีคริสต์ศักราชเป็นปีพุทธศักราชโดยการเพิ่ม 543
      int thaiYear = dateTime.year + 543;

      // ใช้ intl package เพื่อแปลงรูปแบบวันที่
      // String formattedDate = DateFormat('dd-MM-yyyy')
      String formattedDate = DateFormat('dd MMMM yyyy', 'th_TH')
          .format(DateTime(dateTime.year, dateTime.month, dateTime.day));
      formattedDate = formattedDate.substring(0, formattedDate.length - 4);
      // เพิ่มปีพุทธศักราช
      formattedDate += '$thaiYear';

      return formattedDate;
    }

    //  Timestamp.fromDate(DateTime.now());

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        top: true,
        child: isLoadingLogout == true
            ? DataTransferWidgetNoUser(
                success: isLoading,
              )
            : isLoadingData
                ? CircularLoadingHome()
                : Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 10.0, 0.0),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                // context.safePop();
                                                Navigator.pop(context);
                                              },
                                              child: Icon(
                                                Icons.chevron_left,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                size: 40.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 10.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                // context.pushNamed('A01_01_Home');
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
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
                                            style: FlutterFlowTheme.of(context)
                                                .bodyLarge
                                                .override(
                                                  fontFamily: 'Kanit',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
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
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Kanit',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          userData!.isNotEmpty
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      '${userData!['Name']} ${userData!['Surname']}',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                              ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      'สมัครสมาชิกที่นี่',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyLarge
                                                              .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                          userData!.isNotEmpty
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      // 'Last login ${DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(
                                                      //   userData!['DateUpdate']
                                                      //               .seconds *
                                                      //           1000 +
                                                      //       (userData!['DateUpdate']
                                                      //                   .nanoseconds /
                                                      //               1000000)
                                                      //           .round(),
                                                      // ))}',
                                                      'Last login ${formatThaiDate(userData!['DateUpdate'])}',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                              ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      'ล็อกอินเข้าสู่ระบบ',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                      userData!.isNotEmpty
                                          ? Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 0.0, 0.0, 0.0),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  // await saveDataForLogout();

                                                  // Navigator.pushReplacement(
                                                  //     context,
                                                  //     CupertinoPageRoute(
                                                  //       builder: (context) =>
                                                  //           A0105DashboardWidget(),
                                                  //     )).then((value) {
                                                  //   Navigator.pop(context);
                                                  if (mounted) {
                                                    setState(() {});
                                                  }
                                                  // });
                                                  // Navigator.pop(context);
                                                },
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryText,
                                                  maxRadius: 20,
                                                  // radius: 1,
                                                  backgroundImage:
                                                      userData!['Img'] == ''
                                                          ? null
                                                          : NetworkImage(
                                                              userData!['Img']),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      10.0, 0.0, 0.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    hoverColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      // saveDataForLogout();
                                                    },
                                                    child: Icon(
                                                      Icons.account_circle,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 40.0,
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
                          ),
                          // Row(
                          //   mainAxisSize: MainAxisSize.max,
                          //   children: [
                          //     Row(
                          //       mainAxisSize: MainAxisSize.max,
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       children: [
                          //         Column(
                          //           mainAxisSize: MainAxisSize.max,
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             Row(
                          //               mainAxisSize: MainAxisSize.max,
                          //               children: [
                          //                 Column(
                          //                   mainAxisSize: MainAxisSize.max,
                          //                   // mainAxisAlignment:
                          //                   //     MainAxisAlignment.center,
                          //                   children: [
                          //                     Padding(
                          //                       padding:
                          //                           EdgeInsetsDirectional.fromSTEB(
                          //                               0.0, 0.0, 10.0, 0.0),
                          //                       child: InkWell(
                          //                         splashColor: Colors.transparent,
                          //                         focusColor: Colors.transparent,
                          //                         hoverColor: Colors.transparent,
                          //                         highlightColor:
                          //                             Colors.transparent,
                          //                         onTap: () async {
                          //                           Navigator.pop(context);
                          //                           // context.safePop();
                          //                         },
                          //                         child: Icon(
                          //                           Icons.chevron_left,
                          //                           color:
                          //                               FlutterFlowTheme.of(context)
                          //                                   .secondaryText,
                          //                           size: 40.0,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 Padding(
                          //                   padding: EdgeInsetsDirectional.fromSTEB(
                          //                       0.0, 0.0, 10.0, 0.0),
                          //                   child: Column(
                          //                     mainAxisSize: MainAxisSize.max,
                          //                     children: [
                          //                       InkWell(
                          //                         splashColor: Colors.transparent,
                          //                         focusColor: Colors.transparent,
                          //                         hoverColor: Colors.transparent,
                          //                         highlightColor:
                          //                             Colors.transparent,
                          //                         onTap: () async {
                          //                           // context
                          //                           //     .pushNamed('A01_01_Home');
                          //                         },
                          //                         child: ClipRRect(
                          //                           borderRadius:
                          //                               BorderRadius.circular(50.0),
                          //                           child: Image.asset(
                          //                             'assets/images/LINE_ALBUM__231114_1.jpg',
                          //                             width: 40.0,
                          //                             fit: BoxFit.cover,
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //                 Column(
                          //                   mainAxisSize: MainAxisSize.max,
                          //                   children: [
                          //                     Text(
                          //                       'มหาชัยฟู้ดส์ จํากัด',
                          //                       style: FlutterFlowTheme.of(context)
                          //                           .bodyLarge
                          //                           .override(
                          //                             fontFamily: 'Kanit',
                          //                             color: FlutterFlowTheme.of(
                          //                                     context)
                          //                                 .primaryText,
                          //                           ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //         SizedBox(
                          //           width: 130,
                          //         ),
                          //         Column(
                          //           mainAxisSize: MainAxisSize.max,
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             Text(
                          //               'แดชบอร์ด',
                          //               style: FlutterFlowTheme.of(context)
                          //                   .titleMedium
                          //                   .override(
                          //                     fontFamily: 'Kanit',
                          //                     color: FlutterFlowTheme.of(context)
                          //                         .primaryText,
                          //                   ),
                          //             ),
                          //           ],
                          //         ),
                          //         // SizedBox(
                          //         //   width: 190,
                          //         // ),
                          //         Column(
                          //           mainAxisSize: MainAxisSize.max,
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             Row(
                          //               mainAxisSize: MainAxisSize.max,
                          //               children: [
                          //                  Column(
                          //               mainAxisSize: MainAxisSize.max,
                          //               crossAxisAlignment: CrossAxisAlignment.end,
                          //               children: [
                          //                 userData!.isNotEmpty
                          //                     ? Row(
                          //                         mainAxisSize: MainAxisSize.max,
                          //                         children: [
                          //                           Text(
                          //                             '${userData!['Name']} ${userData!['Surname']}',
                          //                             style: FlutterFlowTheme.of(
                          //                                     context)
                          //                                 .bodyLarge
                          //                                 .override(
                          //                                   fontFamily: 'Kanit',
                          //                                   color:
                          //                                       FlutterFlowTheme.of(
                          //                                               context)
                          //                                           .primaryText,
                          //                                 ),
                          //                           ),
                          //                         ],
                          //                       )
                          //                     : Row(
                          //                         mainAxisSize: MainAxisSize.max,
                          //                         children: [
                          //                           Text(
                          //                             'สมัครสมาชิกที่นี่',
                          //                             style: FlutterFlowTheme.of(
                          //                                     context)
                          //                                 .bodyLarge
                          //                                 .override(
                          //                                   fontFamily: 'Kanit',
                          //                                   color:
                          //                                       FlutterFlowTheme.of(
                          //                                               context)
                          //                                           .primaryText,
                          //                                 ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                 userData!.isNotEmpty
                          //                     ? Row(
                          //                         mainAxisSize: MainAxisSize.max,
                          //                         children: [
                          //                           Text(
                          //                             // 'Last login ${DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(
                          //                             //   userData!['DateUpdate']
                          //                             //               .seconds *
                          //                             //           1000 +
                          //                             //       (userData!['DateUpdate']
                          //                             //                   .nanoseconds /
                          //                             //               1000000)
                          //                             //           .round(),
                          //                             // ))}',
                          //                             'Last login ${formatThaiDate(userData!['DateUpdate'])}',
                          //                             style: FlutterFlowTheme.of(
                          //                                     context)
                          //                                 .bodySmall
                          //                                 .override(
                          //                                   fontFamily: 'Kanit',
                          //                                   color:
                          //                                       FlutterFlowTheme.of(
                          //                                               context)
                          //                                           .primaryText,
                          //                                 ),
                          //                           ),
                          //                         ],
                          //                       )
                          //                     : Row(
                          //                         mainAxisSize: MainAxisSize.max,
                          //                         children: [
                          //                           Text(
                          //                             'ล็อกอินเข้าสู่ระบบ',
                          //                             style: FlutterFlowTheme.of(
                          //                                     context)
                          //                                 .bodySmall,
                          //                           ),
                          //                         ],
                          //                       ),
                          //               ],
                          //             ),
                          //                 userData!.isNotEmpty
                          //                     ? Padding(
                          //                         padding: EdgeInsetsDirectional
                          //                             .fromSTEB(
                          //                                 10.0, 0.0, 0.0, 0.0),
                          //                         child: GestureDetector(
                          //                           onTap: () {
                          //                             saveDataForLogout();
                          //                             // Navigator.push(
                          //                             //     context,
                          //                             //     CupertinoPageRoute(
                          //                             //       builder: (context) =>
                          //                             //           A0105DashboardWidget(),
                          //                             //     )).then((value) {
                          //                             //   if (mounted) {
                          //                             //     setState(() {});
                          //                             //   }
                          //                             // });
                          //                           },
                          //                           child: CircleAvatar(
                          //                             backgroundColor:
                          //                                 FlutterFlowTheme.of(
                          //                                         context)
                          //                                     .secondaryText,
                          //                             maxRadius: 20,
                          //                             // radius: 1,
                          //                             backgroundImage:
                          //                                 userData!['Img'] == ''
                          //                                     ? null
                          //                                     : NetworkImage(
                          //                                         userData!['Img']),
                          //                           ),
                          //                         ),
                          //                       )
                          //                     : Padding(
                          //                         padding: EdgeInsetsDirectional
                          //                             .fromSTEB(
                          //                                 10.0, 0.0, 0.0, 0.0),
                          //                         child: Column(
                          //                           mainAxisSize: MainAxisSize.max,
                          //                           children: [
                          //                             InkWell(
                          //                               splashColor:
                          //                                   Colors.transparent,
                          //                               focusColor:
                          //                                   Colors.transparent,
                          //                               hoverColor:
                          //                                   Colors.transparent,
                          //                               highlightColor:
                          //                                   Colors.transparent,
                          //                               onTap: () async {
                          //                                 saveDataForLogout();
                          //                               },
                          //                               child: Icon(
                          //                                 Icons.account_circle,
                          //                                 color:
                          //                                     FlutterFlowTheme.of(
                          //                                             context)
                          //                                         .secondaryText,
                          //                                 size: 40.0,
                          //                               ),
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 15.0, 0.0, 15.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 1.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).alternate,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    15.0, 15.0, 15.0, 15.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  5.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.0),
                                                        // child: Image.asset(
                                                        //   'assets/images/Screenshot_2566-11-14_at_16.09.26.png',
                                                        //   width:
                                                        //       MediaQuery.sizeOf(
                                                        //                   context)
                                                        //               .width *
                                                        //           1.0,
                                                        //   fit: BoxFit.cover,
                                                        // ),
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              height: 100,
                                                              width: 100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                              ),

                                                              child: charts
                                                                  .PieChart<
                                                                      String>(
                                                                layoutConfig: charts
                                                                    .LayoutConfig(
                                                                  leftMarginSpec:
                                                                      charts.MarginSpec
                                                                          .fixedPixel(
                                                                              0),
                                                                  topMarginSpec:
                                                                      charts.MarginSpec
                                                                          .fixedPixel(
                                                                              0),
                                                                  rightMarginSpec:
                                                                      charts.MarginSpec
                                                                          .fixedPixel(
                                                                              0),
                                                                  bottomMarginSpec:
                                                                      charts.MarginSpec
                                                                          .fixedPixel(
                                                                              0),
                                                                ),
                                                                [
                                                                  charts.Series<
                                                                      SalesData,
                                                                      String>(
                                                                    id: 'Sales',
                                                                    domainFn: (SalesData
                                                                                sales,
                                                                            _) =>
                                                                        sales
                                                                            .year,
                                                                    measureFn: (SalesData
                                                                                sales,
                                                                            _) =>
                                                                        sales
                                                                            .sales,
                                                                    data: data,
                                                                    // labelAccessorFn: (SalesData sales, _) => '${sales.year}: ${sales.sales}',
                                                                    labelAccessorFn:
                                                                        (SalesData sales,
                                                                                _) =>
                                                                            // '${sales.sales}',
                                                                            '',
                                                                    colorFn:
                                                                        (SalesData
                                                                                sales,
                                                                            _) {
                                                                      switch (sales
                                                                          .year) {
                                                                        case 'now':
                                                                          return charts.ColorUtil.fromDartColor(Color.fromARGB(
                                                                              255,
                                                                              4,
                                                                              114,
                                                                              37));
                                                                        case 'before':
                                                                          return charts
                                                                              .MaterialPalette
                                                                              .red
                                                                              .shadeDefault;

                                                                        default:
                                                                          return charts.ColorUtil.fromDartColor(Color.fromRGBO(
                                                                              240,
                                                                              118,
                                                                              118,
                                                                              1));
                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                                // _createSampleData(),
                                                                animate: true,
                                                                defaultRenderer:
                                                                    charts.ArcRendererConfig<
                                                                        String>(
                                                                  strokeWidthPx:
                                                                      0.5,
                                                                  arcWidth: 20,
                                                                  arcRendererDecorators: [
                                                                    charts
                                                                        .ArcLabelDecorator()
                                                                  ],
                                                                ),
                                                              ),

                                                              //     PieChartExample(
                                                              //   _createSampleData(),
                                                              //   animate: true,
                                                              // ),

                                                              //     renderChart(
                                                              //   id: 'chart_total_pay_type',
                                                              //   total: [
                                                              //     40,
                                                              //     60
                                                              //   ],
                                                              // ),
                                                            ),
                                                            Positioned(
                                                              bottom: 40,
                                                              left: 40,
                                                              child: SizedBox(
                                                                width: 30,
                                                                height: 20,
                                                                child: Text(
                                                                  '$percentageShow%',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          // '01 มกราคม 2567',

                                                          formatThaiDate(
                                                            Timestamp.fromDate(
                                                                DateTime.now()),
                                                          ),

                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${DateTime.now().hour.toString()} : ${DateTime.now().minute.toString()} น.',

                                                          // '09.00 น.',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          10.0, 0.0, 5.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'เป้าหมายประจำเดือน',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'ยอดปัจจุบัน',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'ต้องการยอดขายเพิ่มอีก',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    '${NumberFormat('#,##0').format(int.parse(userData!['เป้าหมายประจำเดือน']))} บาท',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    '${totalOrderList![0]} บาท',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    '${NumberFormat('#,##0').format((int.parse(userData!['เป้าหมายประจำเดือน']) - totalMonth))} บาท',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    2.0,
                                                                    0.0,
                                                                    2.0),
                                                        child: Container(
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  1.0,
                                                          height: 1.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                            border: Border.all(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'เดือนนี้พบลูกค้าทั้งสิ้น',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'ลูกค้าปฏิเสธการเปิดหน้าบัญชี',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'เปิดหน้าบัญชีได้สําเร็จทั้งสิ้น',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'Conv. Rate',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    '200 ราย',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    '50 ราย',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    '150 ราย',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    '75 %',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5.0, 0.0, 5.0, 0.0),
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  1.0,
                                              height: 1.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 5.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      5.0,
                                                                      0.0),
                                                          child: Icon(
                                                            Icons
                                                                .calendar_month_sharp,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                        Text(
                                                          'ประวัติยอดขายย้อนหลัง',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Kanit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                CupertinoPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          A1600CustomerChoose(
                                                                    id: userData![
                                                                        'UserID'],
                                                                    status:
                                                                        'ทั้งหมด',
                                                                  ),
                                                                ));
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .keyboard_arrow_right_rounded,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        SizedBox(
                                                          height: 30.0,
                                                          child:
                                                              VerticalDivider(
                                                            width: 5.0,
                                                            thickness: 1.0,
                                                            indent: 4.0,
                                                            endIndent: 3.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .accent4,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      2.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    beforeSixMonths![
                                                                        0],
                                                                    // 'beforeSixMonths![0]',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'ยอดขายรวม ${totalOrderList![0]} บาท',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        SizedBox(
                                                          height: 30.0,
                                                          child:
                                                              VerticalDivider(
                                                            width: 5.0,
                                                            thickness: 1.0,
                                                            indent: 4.0,
                                                            endIndent: 3.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .accent4,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      2.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    beforeSixMonths![
                                                                        1],
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'ยอดขายรวม ${totalOrderList![1]} บาท',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        SizedBox(
                                                          height: 30.0,
                                                          child:
                                                              VerticalDivider(
                                                            width: 5.0,
                                                            thickness: 1.0,
                                                            indent: 4.0,
                                                            endIndent: 3.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .accent4,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      2.0,
                                                                      0.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    beforeSixMonths![
                                                                        2],
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'ยอดขายรวม ${totalOrderList![2]} บาท',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 5.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          SizedBox(
                                                            height: 30.0,
                                                            child:
                                                                VerticalDivider(
                                                              width: 5.0,
                                                              thickness: 1.0,
                                                              indent: 4.0,
                                                              endIndent: 3.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .accent4,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        2.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      beforeSixMonths![
                                                                          3],
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryBackground,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      'ยอดขายรวม ${totalOrderList![3]} บาท',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryBackground,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          SizedBox(
                                                            height: 30.0,
                                                            child:
                                                                VerticalDivider(
                                                              width: 5.0,
                                                              thickness: 1.0,
                                                              indent: 4.0,
                                                              endIndent: 3.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .accent4,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        2.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      beforeSixMonths![
                                                                          4],
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryBackground,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      'ยอดขายรวม ${totalOrderList![4]} บาท',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryBackground,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          SizedBox(
                                                            height: 30.0,
                                                            child:
                                                                VerticalDivider(
                                                              width: 5.0,
                                                              thickness: 1.0,
                                                              indent: 4.0,
                                                              endIndent: 3.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .accent4,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        2.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      beforeSixMonths![
                                                                          5],
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryBackground,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Text(
                                                                      'ยอดขายรวม ${totalOrderList![5]} บาท',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryBackground,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            5.0, 0.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 5.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        5.0,
                                                                        0.0),
                                                            child: Icon(
                                                              FFIcons
                                                                  .kcommentAccount,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              size: 20.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            'แผนการเข้าพบลูกค้า ${beforeSixMonths![0]}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        A1301VisitList(),
                                                              ));
                                                        },
                                                        child: Container(
                                                          width: 18.0,
                                                          height: 22.0,
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Icon(
                                                            Icons
                                                                .chevron_right_outlined,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 5.0, 0.0, 2.0),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        1.0,
                                                height: 1.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 2.0),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.32,
                                                decoration: BoxDecoration(),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        for (int i = 0;
                                                            i < 5;
                                                            i++)
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Text(
                                                                visitList![i]![
                                                                    'ชื่อนามสกุล'],
                                                                // 'ร้านสมศรีโภชนา',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Kanit',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        // Row(
                                                        //   mainAxisSize:
                                                        //       MainAxisSize.max,
                                                        //   children: [
                                                        //     Text(
                                                        //       'คลองตันเตี๋ยวปลารสเด็ด',
                                                        //       style: FlutterFlowTheme
                                                        //               .of(context)
                                                        //           .bodyMedium
                                                        //           .override(
                                                        //             fontFamily:
                                                        //                 'Kanit',
                                                        //             color: FlutterFlowTheme.of(
                                                        //                     context)
                                                        //                 .primaryBackground,
                                                        //           ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        // Row(
                                                        //   mainAxisSize:
                                                        //       MainAxisSize.max,
                                                        //   children: [
                                                        //     Text(
                                                        //       'แม่จิตโภชนา',
                                                        //       style: FlutterFlowTheme
                                                        //               .of(context)
                                                        //           .bodyMedium
                                                        //           .override(
                                                        //             fontFamily:
                                                        //                 'Kanit',
                                                        //             color: FlutterFlowTheme.of(
                                                        //                     context)
                                                        //                 .primaryBackground,
                                                        //           ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        // Row(
                                                        //   mainAxisSize:
                                                        //       MainAxisSize.max,
                                                        //   children: [
                                                        //     Text(
                                                        //       'ก้วยเตี๋ยวปลาแม่คํานึง',
                                                        //       style: FlutterFlowTheme
                                                        //               .of(context)
                                                        //           .bodyMedium
                                                        //           .override(
                                                        //             fontFamily:
                                                        //                 'Kanit',
                                                        //             color: FlutterFlowTheme.of(
                                                        //                     context)
                                                        //                 .primaryBackground,
                                                        //           ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        // Row(
                                                        //   mainAxisSize:
                                                        //       MainAxisSize.max,
                                                        //   children: [
                                                        //     Text(
                                                        //       'โต้งข้าวต้มโต้รุ่งซอยราม 54',
                                                        //       style: FlutterFlowTheme
                                                        //               .of(context)
                                                        //           .bodyMedium
                                                        //           .override(
                                                        //             fontFamily:
                                                        //                 'Kanit',
                                                        //             color: FlutterFlowTheme.of(
                                                        //                     context)
                                                        //                 .primaryBackground,
                                                        //           ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        for (int i = 0;
                                                            i < 5;
                                                            i++)
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  visitList![i]![
                                                                              'วันเดือนปีนัดหมาย'] ==
                                                                          null
                                                                      ? ''
                                                                      : formatThaiDate(
                                                                          visitList![i]![
                                                                              'วันเดือนปีนัดหมาย']),
                                                                  // '10 ธค 2560',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBackground,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        // Row(
                                                        //   mainAxisSize:
                                                        //       MainAxisSize.max,
                                                        //   children: [
                                                        //     Text(
                                                        //       '10 ธค 2560',
                                                        //       style: FlutterFlowTheme
                                                        //               .of(context)
                                                        //           .bodyMedium
                                                        //           .override(
                                                        //             fontFamily:
                                                        //                 'Kanit',
                                                        //             color: FlutterFlowTheme.of(
                                                        //                     context)
                                                        //                 .primaryBackground,
                                                        //           ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        // Row(
                                                        //   mainAxisSize:
                                                        //       MainAxisSize.max,
                                                        //   children: [
                                                        //     Text(
                                                        //       '10 ธค 2560',
                                                        //       style: FlutterFlowTheme
                                                        //               .of(context)
                                                        //           .bodyMedium
                                                        //           .override(
                                                        //             fontFamily:
                                                        //                 'Kanit',
                                                        //             color: FlutterFlowTheme.of(
                                                        //                     context)
                                                        //                 .primaryBackground,
                                                        //           ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        // Row(
                                                        //   mainAxisSize:
                                                        //       MainAxisSize.max,
                                                        //   children: [
                                                        //     Text(
                                                        //       '10 ธค 2560',
                                                        //       style: FlutterFlowTheme
                                                        //               .of(context)
                                                        //           .bodyMedium
                                                        //           .override(
                                                        //             fontFamily:
                                                        //                 'Kanit',
                                                        //             color: FlutterFlowTheme.of(
                                                        //                     context)
                                                        //                 .primaryBackground,
                                                        //           ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                        // Row(
                                                        //   mainAxisSize:
                                                        //       MainAxisSize.max,
                                                        //   children: [
                                                        //     Text(
                                                        //       '10 ธค 2560',
                                                        //       style: FlutterFlowTheme
                                                        //               .of(context)
                                                        //           .bodyMedium
                                                        //           .override(
                                                        //             fontFamily:
                                                        //                 'Kanit',
                                                        //             color: FlutterFlowTheme.of(
                                                        //                     context)
                                                        //                 .primaryBackground,
                                                        //           ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 3.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        5.0,
                                                                        0.0),
                                                            child: Icon(
                                                              Icons
                                                                  .watch_later_sharp,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryBackground,
                                                              size: 20.0,
                                                            ),
                                                          ),
                                                          Text(
                                                            'ประวัติการเข้าพบ',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Kanit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryBackground,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        A1501ReportCheckIn(),
                                                              ));
                                                        },
                                                        child: Container(
                                                          width: 18.0,
                                                          height: 22.0,
                                                          decoration:
                                                              BoxDecoration(),
                                                          child: Icon(
                                                            Icons
                                                                .chevron_right_outlined,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 5.0, 0.0, 2.0),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        1.0,
                                                height: 1.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 2.0),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.32,
                                                decoration: BoxDecoration(),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        for (int i = 0;
                                                            i < 5;
                                                            i++)
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Text(
                                                                visitBeforeList![
                                                                        i]![
                                                                    'ชื่อนามสกุล'],
                                                                // 'ร้านสมศรีโภชนา',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Kanit',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        for (int i = 0;
                                                            i < 5;
                                                            i++)
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  visitBeforeList![i]![
                                                                              'วันเดือนปีนัดหมาย'] ==
                                                                          null
                                                                      ? ''
                                                                      : formatThaiDate(
                                                                          visitBeforeList![i]![
                                                                              'วันเดือนปีนัดหมาย']),
                                                                  // '10 ธค 2560',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBackground,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // Container(
                                            //   width: MediaQuery.sizeOf(context)
                                            //           .width *
                                            //       0.32,
                                            //   decoration: BoxDecoration(),
                                            //   child: Padding(
                                            //     padding: EdgeInsetsDirectional
                                            //         .fromSTEB(
                                            //             0.0, 3.0, 0.0, 0.0),
                                            //     child: Row(
                                            //       mainAxisSize:
                                            //           MainAxisSize.max,
                                            //       mainAxisAlignment:
                                            //           MainAxisAlignment
                                            //               .spaceBetween,
                                            //       children: [
                                            //         Column(
                                            //           mainAxisSize:
                                            //               MainAxisSize.max,
                                            //           crossAxisAlignment:
                                            //               CrossAxisAlignment
                                            //                   .start,
                                            //           children: [
                                            //             Row(
                                            //               mainAxisSize:
                                            //                   MainAxisSize.max,
                                            //               children: [
                                            //                 Text(
                                            //                   'มีนบุรี',
                                            //                   style: FlutterFlowTheme
                                            //                           .of(context)
                                            //                       .bodyMedium
                                            //                       .override(
                                            //                         fontFamily:
                                            //                             'Kanit',
                                            //                         color: FlutterFlowTheme.of(
                                            //                                 context)
                                            //                             .primaryBackground,
                                            //                       ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //             Row(
                                            //               mainAxisSize:
                                            //                   MainAxisSize.max,
                                            //               children: [
                                            //                 Text(
                                            //                   'คลองตัน',
                                            //                   style: FlutterFlowTheme
                                            //                           .of(context)
                                            //                       .bodyMedium
                                            //                       .override(
                                            //                         fontFamily:
                                            //                             'Kanit',
                                            //                         color: FlutterFlowTheme.of(
                                            //                                 context)
                                            //                             .primaryBackground,
                                            //                       ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //             Row(
                                            //               mainAxisSize:
                                            //                   MainAxisSize.max,
                                            //               children: [
                                            //                 Text(
                                            //                   'พระราม 9',
                                            //                   style: FlutterFlowTheme
                                            //                           .of(context)
                                            //                       .bodyMedium
                                            //                       .override(
                                            //                         fontFamily:
                                            //                             'Kanit',
                                            //                         color: FlutterFlowTheme.of(
                                            //                                 context)
                                            //                             .primaryBackground,
                                            //                       ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //             Row(
                                            //               mainAxisSize:
                                            //                   MainAxisSize.max,
                                            //               children: [
                                            //                 Text(
                                            //                   'คลองตัน',
                                            //                   style: FlutterFlowTheme
                                            //                           .of(context)
                                            //                       .bodyMedium
                                            //                       .override(
                                            //                         fontFamily:
                                            //                             'Kanit',
                                            //                         color: FlutterFlowTheme.of(
                                            //                                 context)
                                            //                             .primaryBackground,
                                            //                       ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //             Row(
                                            //               mainAxisSize:
                                            //                   MainAxisSize.max,
                                            //               children: [
                                            //                 Text(
                                            //                   'พระราม 9',
                                            //                   style: FlutterFlowTheme
                                            //                           .of(context)
                                            //                       .bodyMedium
                                            //                       .override(
                                            //                         fontFamily:
                                            //                             'Kanit',
                                            //                         color: FlutterFlowTheme.of(
                                            //                                 context)
                                            //                             .primaryBackground,
                                            //                       ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ],
                                            //         ),
                                            //         Column(
                                            //           mainAxisSize:
                                            //               MainAxisSize.max,
                                            //           children: [
                                            //             Row(
                                            //               mainAxisSize:
                                            //                   MainAxisSize.max,
                                            //               children: [
                                            //                 Text(
                                            //                   '10 ราย',
                                            //                   style: FlutterFlowTheme
                                            //                           .of(context)
                                            //                       .bodyMedium
                                            //                       .override(
                                            //                         fontFamily:
                                            //                             'Kanit',
                                            //                         color: FlutterFlowTheme.of(
                                            //                                 context)
                                            //                             .primaryBackground,
                                            //                       ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //             Row(
                                            //               mainAxisSize:
                                            //                   MainAxisSize.max,
                                            //               children: [
                                            //                 Text(
                                            //                   '10 ราย',
                                            //                   style: FlutterFlowTheme
                                            //                           .of(context)
                                            //                       .bodyMedium
                                            //                       .override(
                                            //                         fontFamily:
                                            //                             'Kanit',
                                            //                         color: FlutterFlowTheme.of(
                                            //                                 context)
                                            //                             .primaryBackground,
                                            //                       ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //             Row(
                                            //               mainAxisSize:
                                            //                   MainAxisSize.max,
                                            //               children: [
                                            //                 Text(
                                            //                   '10 ราย',
                                            //                   style: FlutterFlowTheme
                                            //                           .of(context)
                                            //                       .bodyMedium
                                            //                       .override(
                                            //                         fontFamily:
                                            //                             'Kanit',
                                            //                         color: FlutterFlowTheme.of(
                                            //                                 context)
                                            //                             .primaryBackground,
                                            //                       ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //             Row(
                                            //               mainAxisSize:
                                            //                   MainAxisSize.max,
                                            //               children: [
                                            //                 Text(
                                            //                   '10 ราย',
                                            //                   style: FlutterFlowTheme
                                            //                           .of(context)
                                            //                       .bodyMedium
                                            //                       .override(
                                            //                         fontFamily:
                                            //                             'Kanit',
                                            //                         color: FlutterFlowTheme.of(
                                            //                                 context)
                                            //                             .primaryBackground,
                                            //                       ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //             Row(
                                            //               mainAxisSize:
                                            //                   MainAxisSize.max,
                                            //               children: [
                                            //                 Text(
                                            //                   '10 ราย',
                                            //                   style: FlutterFlowTheme
                                            //                           .of(context)
                                            //                       .bodyMedium
                                            //                       .override(
                                            //                         fontFamily:
                                            //                             'Kanit',
                                            //                         color: FlutterFlowTheme.of(
                                            //                                 context)
                                            //                             .primaryBackground,
                                            //                       ),
                                            //                 ),
                                            //               ],
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: GridView(
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio: 1.0,
                                  ),
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        // context.pushNamed('A07_01_OpenAccount');
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  A1101EditUserProfile(),
                                            )).then((value) => setState(() {}));
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.kaccountCircle,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'แก้ไขจัดการโปรไฟล์',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        // context.pushNamed('A07_01_OpenAccount');
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  A0701OpenAccountWidget(),
                                            ));
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.knotePlus,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'เปิดหน้าบัญชีลูกค้า',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                A0713AcceptWidget(),
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.fact_check,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'ผลการอนุมัติเปิดบัญชี',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                A0801CustomerRatingGroup(),
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.kfolderAccount,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'บัญชีลูกค้าในระบบ',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                A1001CustomerCreditList(),
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.kaccountSearch,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'เช็คเครดิตลูกค้า',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width ==
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  A0900ChoosePage()
                                              // A0901CustomerList(),
                                              )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.kfileDocumentPlus,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'เปิดใบสั่งขายสินค้า',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                // A1601CustomerWaitOrderMenu(),

                                                A1600CustomerChoose(
                                              id: userData!['UserID'],
                                              status: 'ทั้งหมด',
                                            ),
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.knoteCheck,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รายการอนุมัติสั่งขาย',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                A1701PlanSend(),
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.ktruck,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'แผนการจัดส่งสินค้า',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                A1701PlanSend(),
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.ktruckDelivery,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'สถานะการส่งสินค้า',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                A1600CustomerChoose(
                                              id: userData!['UserID'],
                                              status: 'ทั้งหมด',
                                            ),
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.kchartBox,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รีพอร์ทการขาย',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                A1301VisitList(),
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.ktargetAccount,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'วางแผนเข้าเยี่ยมลูกค้า',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                A1301VisitList(),
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons
                                                        .kcalendarAccountOutline,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'ตารางแผนเข้าเยี่ยม',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                A1401VisitSaveTime(),
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.kcalendarClock,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'เก็บเวลาเข้าเยี่ยม',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                A1501ReportCheckIn(),
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.kclipboardTextClock,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รีพอร์ทการเยี่ยมลูกค้า',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Column(
                                    //   mainAxisSize: MainAxisSize.max,
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   children: [
                                    //     Padding(
                                    //       padding:
                                    //           EdgeInsetsDirectional.fromSTEB(
                                    //               0.0, 0.0, 0.0, 5.0),
                                    //       child: Row(
                                    //         mainAxisSize: MainAxisSize.max,
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.center,
                                    //         children: [
                                    //           Container(
                                    //             width: 60.0,
                                    //             height: 60.0,
                                    //             decoration: BoxDecoration(
                                    //               color: FlutterFlowTheme.of(
                                    //                       context)
                                    //                   .secondaryText,
                                    //               borderRadius:
                                    //                   BorderRadius.circular(
                                    //                       20.0),
                                    //             ),
                                    //             child: Icon(
                                    //               FFIcons.kfileDocumentMultiple,
                                    //               color: FlutterFlowTheme.of(
                                    //                       context)
                                    //                   .primaryBackground,
                                    //               size: 40.0,
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //     Row(
                                    //       mainAxisSize: MainAxisSize.max,
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.center,
                                    //       children: [
                                    //         Text(
                                    //           'แบบฟอร์มเอกสาร',
                                    //           style:
                                    //               FlutterFlowTheme.of(context)
                                    //                   .bodySmall
                                    //                   .override(
                                    //                     fontFamily: 'Kanit',
                                    //                     fontSize: MediaQuery.sizeOf(
                                    //                                     context)
                                    //                                 .width >=
                                    //                             800.0
                                    //                         ? 13.0
                                    //                         : 10.0,
                                    //                   ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ],
                                    // ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  A2001AddNewCustomerFirst(),
                                            ));
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.kaccountEdit,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'เก็บข้อมูลลูกค้าใหม่',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                A2300ChooseSetting(),
                                          )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.kaccountGroup,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'การจัดการทีมขาย',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      // onTap: () => Navigator.push(
                                      //     context,
                                      //     CupertinoPageRoute(
                                      //       builder: (context) =>
                                      //           A2400ChooseReport(),
                                      //     )),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText.withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons.kfinance,
                                                    color: Colors.white,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'รายงาน',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  A2201CustomerPdpaList(),
                                            ));
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    FFIcons
                                                        .kshieldAccountOutline,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'จัดการ PDPA ในระบบ',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  A2101Version(),
                                            ));
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 5.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 60.0,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .alternate,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Icon(
                                                    Icons.app_shortcut,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'เวอร์ชั่น',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily: 'Kanit',
                                                          fontSize: MediaQuery.sizeOf(
                                                                          context)
                                                                      .width >=
                                                                  800.0
                                                              ? 13.0
                                                              : 10.0,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 10.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                1.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      15.0, 15.0, 15.0, 15.0),
                                              child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        1.0,
                                                decoration: BoxDecoration(),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  'Top เซลล์ประจําเดือน',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBackground,
                                                                      ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        CupertinoPageRoute(
                                                                          builder: (context) => A010502SalesList(
                                                                              topSaleImg: topSaleImg,
                                                                              topSaleName: topSaleName,
                                                                              topSaleTotal: topSaleTotal),
                                                                          // A010501NewsDetail(),
                                                                        ));
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .chevron_right_sharp,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryBackground,
                                                                    size: 24.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/LINE_ALBUM__231114_1.jpg',
                                                                width: 30.0,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    // for (int i = 0; i < 4; i++)
                                                    //   Padding(
                                                    //     padding:
                                                    //         EdgeInsetsDirectional
                                                    //             .fromSTEB(
                                                    //                 0.0,
                                                    //                 10.0,
                                                    //                 0.0,
                                                    //                 0.0),
                                                    //     child: Row(
                                                    //       mainAxisSize:
                                                    //           MainAxisSize.max,
                                                    //       mainAxisAlignment:
                                                    //           MainAxisAlignment
                                                    //               .start,
                                                    //       children: [
                                                    //         Column(
                                                    //           mainAxisSize:
                                                    //               MainAxisSize
                                                    //                   .max,
                                                    //           children: [
                                                    //             Padding(
                                                    //               padding: EdgeInsetsDirectional
                                                    //                   .fromSTEB(
                                                    //                       0.0,
                                                    //                       0.0,
                                                    //                       8.0,
                                                    //                       0.0),
                                                    //               child:
                                                    //                   ClipRRect(
                                                    //                 borderRadius:
                                                    //                     BorderRadius.circular(
                                                    //                         8.0),
                                                    //                 child: topSaleImg[i] ==
                                                    //                         null
                                                    //                     ? Container(
                                                    //                         width:
                                                    //                             40.0,
                                                    //                         height:
                                                    //                             40.0,
                                                    //                         color:
                                                    //                             FlutterFlowTheme.of(context).alternate,
                                                    //                       )
                                                    //                     : topSaleImg[i] ==
                                                    //                             ''
                                                    //                         ? Container(
                                                    //                             width: 40.0,
                                                    //                             height: 40.0,
                                                    //                             color: Colors.grey,
                                                    //                           )
                                                    //                         : Image.network(
                                                    //                             // 'assets/images/shutterstock_674309551.jpg',
                                                    //                             topSaleImg[i]!,
                                                    //                             width: 40.0,
                                                    //                             height: 40.0,
                                                    //                             fit: BoxFit.cover,
                                                    //                           ),
                                                    //               ),
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //         Column(
                                                    //           mainAxisSize:
                                                    //               MainAxisSize
                                                    //                   .max,
                                                    //           crossAxisAlignment:
                                                    //               CrossAxisAlignment
                                                    //                   .start,
                                                    //           children: [
                                                    //             Row(
                                                    //               mainAxisSize:
                                                    //                   MainAxisSize
                                                    //                       .max,
                                                    //               children: [
                                                    //                 Text(
                                                    //                   topSaleName[
                                                    //                       i],
                                                    //                   // 'นายพฤตินัย พรมวิสิทธิ์สุนทร',
                                                    //                   style: FlutterFlowTheme.of(
                                                    //                           context)
                                                    //                       .bodySmall
                                                    //                       .override(
                                                    //                         fontFamily:
                                                    //                             'Kanit',
                                                    //                         color:
                                                    //                             FlutterFlowTheme.of(context).primaryBackground,
                                                    //                         fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                    //                             ? 13.0
                                                    //                             : 10.0,
                                                    //                       ),
                                                    //                 ),
                                                    //               ],
                                                    //             ),
                                                    //             Row(
                                                    //               mainAxisSize:
                                                    //                   MainAxisSize
                                                    //                       .max,
                                                    //               children: [
                                                    //                 Text(
                                                    //                   topSaleTotal[i] ==
                                                    //                           0
                                                    //                       ? ''
                                                    //                       : 'ยอดขาย ${NumberFormat('#,##0').format(topSaleTotal[i])} บาท',
                                                    //                   style: FlutterFlowTheme.of(
                                                    //                           context)
                                                    //                       .bodySmall
                                                    //                       .override(
                                                    //                         fontFamily:
                                                    //                             'Kanit',
                                                    //                         color:
                                                    //                             FlutterFlowTheme.of(context).primaryBackground,
                                                    //                         fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                    //                             ? 13.0
                                                    //                             : 10.0,
                                                    //                       ),
                                                    //                 ),
                                                    //               ],
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //       ],
                                                    //     ),
                                                    //   ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  10.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/young-caucasian-man-formal-shirt-tie-sitting-office-working-computer_1098-20584.jpg',
                                                                    width: 40.0,
                                                                    height:
                                                                        40.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'นายพฤตินัย พรมวิสิทธิ์สุนทร',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                          fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                                              ? 13.0
                                                                              : 10.0,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'ยอดขาย 190,000 บาท',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                          fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                                              ? 13.0
                                                                              : 10.0,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  10.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/GettyImages-1318459282.jpg',
                                                                    width: 40.0,
                                                                    height:
                                                                        40.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'นายพฤตินัย พรมวิสิทธิ์สุนทร',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                          fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                                              ? 13.0
                                                                              : 10.0,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'ยอดขาย 190,000 บาท',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                          fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                                              ? 13.0
                                                                              : 10.0,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  10.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/31047129_m.jpg',
                                                                    width: 40.0,
                                                                    height:
                                                                        40.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'นายพฤตินัย พรมวิสิทธิ์สุนทร',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                          fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                                              ? 13.0
                                                                              : 10.0,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'ยอดขาย 190,000 บาท',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Kanit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryBackground,
                                                                          fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                                              ? 13.0
                                                                              : 10.0,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      thickness: 1.0,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .accent4,
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  'ข่าวสารจากองค์กร',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBackground,
                                                                      ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        CupertinoPageRoute(
                                                                          builder: (context) =>
                                                                              A010500NewsList(newsList: newsList),
                                                                          // A010501NewsDetail(),
                                                                        ));
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .chevron_right_sharp,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryBackground,
                                                                    size: 24.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional(
                                                                      0.00,
                                                                      0.00),
                                                              child: Container(
                                                                width: 20.0,
                                                                height: 20.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .error,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                alignment:
                                                                    AlignmentDirectional(
                                                                        0.00,
                                                                        0.00),
                                                                child: Text(
                                                                  '${newsListLength.length.toString()}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .override(
                                                                        fontFamily:
                                                                            'Kanit',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryBackground,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    for (int i = 0; i < 7; i++)
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        A010501NewsDetail(
                                                                  head: newsList[
                                                                          i][
                                                                      'หัวข้อ'],
                                                                  detail: newsList[
                                                                          i][
                                                                      'รายละเอียด'],
                                                                  day: formatThaiDate(
                                                                      newsList[
                                                                              i]
                                                                          [
                                                                          'วันที่อัพเดท']),
                                                                ),
                                                              ));
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      8.0,
                                                                      0.0,
                                                                      0.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            5.0,
                                                                            0.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    newsList[i]['หัวข้อ'] ==
                                                                            ''
                                                                        ? const SizedBox(
                                                                            height:
                                                                                20,
                                                                          )
                                                                        : Icon(
                                                                            Icons.newspaper_sharp,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryBackground,
                                                                            size:
                                                                                20.0,
                                                                          ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.25,
                                                                    decoration:
                                                                        BoxDecoration(),
                                                                    child: Text(
                                                                      newsList[
                                                                              i]
                                                                          [
                                                                          'หัวข้อ'],
                                                                      // 'ประกาศนโยบายเรื่องการคุ้มครองข้อมูลส่วนบุคคลของลูกค้าในระบบ...',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodySmall
                                                                          .override(
                                                                            fontFamily:
                                                                                'Kanit',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryBackground,
                                                                            fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                                                ? 12.0
                                                                                : 10.0,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      newsList[i]['วันที่อัพเดท'] ==
                                                                              null
                                                                          ? Text(
                                                                              '',
                                                                              // '09 พย 2566',
                                                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                    fontFamily: 'Kanit',
                                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                    fontSize: MediaQuery.sizeOf(context).width >= 800.0 ? 10.0 : 8.0,
                                                                                  ),
                                                                            )
                                                                          : Text(
                                                                              formatThaiDate(newsList[i]['วันที่อัพเดท']),
                                                                              // '09 พย 2566',
                                                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                    fontFamily: 'Kanit',
                                                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                    fontSize: MediaQuery.sizeOf(context).width >= 800.0 ? 10.0 : 8.0,
                                                                                  ),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    // Padding(
                                                    //   padding:
                                                    //       EdgeInsetsDirectional
                                                    //           .fromSTEB(
                                                    //               0.0,
                                                    //               8.0,
                                                    //               0.0,
                                                    //               0.0),
                                                    //   child: Row(
                                                    //     mainAxisSize:
                                                    //         MainAxisSize.max,
                                                    //     crossAxisAlignment:
                                                    //         CrossAxisAlignment
                                                    //             .start,
                                                    //     children: [
                                                    //       Padding(
                                                    //         padding:
                                                    //             EdgeInsetsDirectional
                                                    //                 .fromSTEB(
                                                    //                     0.0,
                                                    //                     0.0,
                                                    //                     5.0,
                                                    //                     0.0),
                                                    //         child: Column(
                                                    //           mainAxisSize:
                                                    //               MainAxisSize
                                                    //                   .max,
                                                    //           children: [
                                                    //             Icon(
                                                    //               Icons
                                                    //                   .newspaper_sharp,
                                                    //               color: FlutterFlowTheme.of(
                                                    //                       context)
                                                    //                   .secondaryBackground,
                                                    //               size: 20.0,
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //       Column(
                                                    //         mainAxisSize:
                                                    //             MainAxisSize
                                                    //                 .max,
                                                    //         crossAxisAlignment:
                                                    //             CrossAxisAlignment
                                                    //                 .start,
                                                    //         children: [
                                                    //           Container(
                                                    //             width: MediaQuery.sizeOf(
                                                    //                         context)
                                                    //                     .width *
                                                    //                 0.25,
                                                    //             decoration:
                                                    //                 BoxDecoration(),
                                                    //             child: Text(
                                                    //               'ประกาศนโยบายเรื่องการคุ้มครองข้อมูลส่วนบุคคลของลูกค้าในระบบ...',
                                                    //               style: FlutterFlowTheme.of(
                                                    //                       context)
                                                    //                   .bodySmall
                                                    //                   .override(
                                                    //                     fontFamily:
                                                    //                         'Kanit',
                                                    //                     color: FlutterFlowTheme.of(context)
                                                    //                         .primaryBackground,
                                                    //                     fontSize: MediaQuery.sizeOf(context).width >=
                                                    //                             800.0
                                                    //                         ? 12.0
                                                    //                         : 10.0,
                                                    //                   ),
                                                    //             ),
                                                    //           ),
                                                    //           Row(
                                                    //             mainAxisSize:
                                                    //                 MainAxisSize
                                                    //                     .max,
                                                    //             children: [
                                                    //               Text(
                                                    //                 '09 พย 2566',
                                                    //                 style: FlutterFlowTheme.of(
                                                    //                         context)
                                                    //                     .bodySmall
                                                    //                     .override(
                                                    //                       fontFamily:
                                                    //                           'Kanit',
                                                    //                       color:
                                                    //                           FlutterFlowTheme.of(context).secondaryBackground,
                                                    //                       fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                    //                           ? 10.0
                                                    //                           : 8.0,
                                                    //                     ),
                                                    //               ),
                                                    //             ],
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    // Padding(
                                                    //   padding:
                                                    //       EdgeInsetsDirectional
                                                    //           .fromSTEB(
                                                    //               0.0,
                                                    //               8.0,
                                                    //               0.0,
                                                    //               0.0),
                                                    //   child: Row(
                                                    //     mainAxisSize:
                                                    //         MainAxisSize.max,
                                                    //     crossAxisAlignment:
                                                    //         CrossAxisAlignment
                                                    //             .start,
                                                    //     children: [
                                                    //       Padding(
                                                    //         padding:
                                                    //             EdgeInsetsDirectional
                                                    //                 .fromSTEB(
                                                    //                     0.0,
                                                    //                     0.0,
                                                    //                     5.0,
                                                    //                     0.0),
                                                    //         child: Column(
                                                    //           mainAxisSize:
                                                    //               MainAxisSize
                                                    //                   .max,
                                                    //           children: [
                                                    //             Icon(
                                                    //               Icons
                                                    //                   .newspaper_sharp,
                                                    //               color: FlutterFlowTheme.of(
                                                    //                       context)
                                                    //                   .secondaryBackground,
                                                    //               size: 20.0,
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //       Column(
                                                    //         mainAxisSize:
                                                    //             MainAxisSize
                                                    //                 .max,
                                                    //         crossAxisAlignment:
                                                    //             CrossAxisAlignment
                                                    //                 .start,
                                                    //         children: [
                                                    //           Container(
                                                    //             width: MediaQuery.sizeOf(
                                                    //                         context)
                                                    //                     .width *
                                                    //                 0.25,
                                                    //             decoration:
                                                    //                 BoxDecoration(),
                                                    //             child: Text(
                                                    //               'ประกาศนโยบายเรื่องการคุ้มครองข้อมูลส่วนบุคคลของลูกค้าในระบบ...',
                                                    //               style: FlutterFlowTheme.of(
                                                    //                       context)
                                                    //                   .bodySmall
                                                    //                   .override(
                                                    //                     fontFamily:
                                                    //                         'Kanit',
                                                    //                     color: FlutterFlowTheme.of(context)
                                                    //                         .primaryBackground,
                                                    //                     fontSize: MediaQuery.sizeOf(context).width >=
                                                    //                             800.0
                                                    //                         ? 12.0
                                                    //                         : 10.0,
                                                    //                   ),
                                                    //             ),
                                                    //           ),
                                                    //           Row(
                                                    //             mainAxisSize:
                                                    //                 MainAxisSize
                                                    //                     .max,
                                                    //             children: [
                                                    //               Text(
                                                    //                 '09 พย 2566',
                                                    //                 style: FlutterFlowTheme.of(
                                                    //                         context)
                                                    //                     .bodySmall
                                                    //                     .override(
                                                    //                       fontFamily:
                                                    //                           'Kanit',
                                                    //                       color:
                                                    //                           FlutterFlowTheme.of(context).secondaryBackground,
                                                    //                       fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                    //                           ? 10.0
                                                    //                           : 8.0,
                                                    //                     ),
                                                    //               ),
                                                    //             ],
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    // Padding(
                                                    //   padding:
                                                    //       EdgeInsetsDirectional
                                                    //           .fromSTEB(
                                                    //               0.0,
                                                    //               8.0,
                                                    //               0.0,
                                                    //               0.0),
                                                    //   child: Row(
                                                    //     mainAxisSize:
                                                    //         MainAxisSize.max,
                                                    //     crossAxisAlignment:
                                                    //         CrossAxisAlignment
                                                    //             .start,
                                                    //     children: [
                                                    //       Padding(
                                                    //         padding:
                                                    //             EdgeInsetsDirectional
                                                    //                 .fromSTEB(
                                                    //                     0.0,
                                                    //                     0.0,
                                                    //                     5.0,
                                                    //                     0.0),
                                                    //         child: Column(
                                                    //           mainAxisSize:
                                                    //               MainAxisSize
                                                    //                   .max,
                                                    //           children: [
                                                    //             Icon(
                                                    //               Icons
                                                    //                   .newspaper_sharp,
                                                    //               color: FlutterFlowTheme.of(
                                                    //                       context)
                                                    //                   .secondaryBackground,
                                                    //               size: 20.0,
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //       Column(
                                                    //         mainAxisSize:
                                                    //             MainAxisSize
                                                    //                 .max,
                                                    //         crossAxisAlignment:
                                                    //             CrossAxisAlignment
                                                    //                 .start,
                                                    //         children: [
                                                    //           Container(
                                                    //             width: MediaQuery.sizeOf(
                                                    //                         context)
                                                    //                     .width *
                                                    //                 0.25,
                                                    //             decoration:
                                                    //                 BoxDecoration(),
                                                    //             child: Text(
                                                    //               'ประกาศนโยบายเรื่องการคุ้มครองข้อมูลส่วนบุคคลของลูกค้าในระบบ...',
                                                    //               style: FlutterFlowTheme.of(
                                                    //                       context)
                                                    //                   .bodySmall
                                                    //                   .override(
                                                    //                     fontFamily:
                                                    //                         'Kanit',
                                                    //                     color: FlutterFlowTheme.of(context)
                                                    //                         .primaryBackground,
                                                    //                     fontSize: MediaQuery.sizeOf(context).width >=
                                                    //                             800.0
                                                    //                         ? 12.0
                                                    //                         : 10.0,
                                                    //                   ),
                                                    //             ),
                                                    //           ),
                                                    //           Row(
                                                    //             mainAxisSize:
                                                    //                 MainAxisSize
                                                    //                     .max,
                                                    //             children: [
                                                    //               Text(
                                                    //                 '09 พย 2566',
                                                    //                 style: FlutterFlowTheme.of(
                                                    //                         context)
                                                    //                     .bodySmall
                                                    //                     .override(
                                                    //                       fontFamily:
                                                    //                           'Kanit',
                                                    //                       color:
                                                    //                           FlutterFlowTheme.of(context).secondaryBackground,
                                                    //                       fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                    //                           ? 10.0
                                                    //                           : 8.0,
                                                    //                     ),
                                                    //               ),
                                                    //             ],
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    // Padding(
                                                    //   padding:
                                                    //       EdgeInsetsDirectional
                                                    //           .fromSTEB(
                                                    //               0.0,
                                                    //               8.0,
                                                    //               0.0,
                                                    //               0.0),
                                                    //   child: Row(
                                                    //     mainAxisSize:
                                                    //         MainAxisSize.max,
                                                    //     crossAxisAlignment:
                                                    //         CrossAxisAlignment
                                                    //             .start,
                                                    //     children: [
                                                    //       Padding(
                                                    //         padding:
                                                    //             EdgeInsetsDirectional
                                                    //                 .fromSTEB(
                                                    //                     0.0,
                                                    //                     0.0,
                                                    //                     5.0,
                                                    //                     0.0),
                                                    //         child: Column(
                                                    //           mainAxisSize:
                                                    //               MainAxisSize
                                                    //                   .max,
                                                    //           children: [
                                                    //             Icon(
                                                    //               Icons
                                                    //                   .newspaper_sharp,
                                                    //               color: FlutterFlowTheme.of(
                                                    //                       context)
                                                    //                   .secondaryBackground,
                                                    //               size: 20.0,
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //       Column(
                                                    //         mainAxisSize:
                                                    //             MainAxisSize
                                                    //                 .max,
                                                    //         crossAxisAlignment:
                                                    //             CrossAxisAlignment
                                                    //                 .start,
                                                    //         children: [
                                                    //           Container(
                                                    //             width: MediaQuery.sizeOf(
                                                    //                         context)
                                                    //                     .width *
                                                    //                 0.25,
                                                    //             decoration:
                                                    //                 BoxDecoration(),
                                                    //             child: Text(
                                                    //               'ประกาศนโยบายเรื่องการคุ้มครองข้อมูลส่วนบุคคลของลูกค้าในระบบ...',
                                                    //               style: FlutterFlowTheme.of(
                                                    //                       context)
                                                    //                   .bodySmall
                                                    //                   .override(
                                                    //                     fontFamily:
                                                    //                         'Kanit',
                                                    //                     color: FlutterFlowTheme.of(context)
                                                    //                         .primaryBackground,
                                                    //                     fontSize: MediaQuery.sizeOf(context).width >=
                                                    //                             800.0
                                                    //                         ? 12.0
                                                    //                         : 10.0,
                                                    //                   ),
                                                    //             ),
                                                    //           ),
                                                    //           Row(
                                                    //             mainAxisSize:
                                                    //                 MainAxisSize
                                                    //                     .max,
                                                    //             children: [
                                                    //               Text(
                                                    //                 '09 พย 2566',
                                                    //                 style: FlutterFlowTheme.of(
                                                    //                         context)
                                                    //                     .bodySmall
                                                    //                     .override(
                                                    //                       fontFamily:
                                                    //                           'Kanit',
                                                    //                       color:
                                                    //                           FlutterFlowTheme.of(context).secondaryBackground,
                                                    //                       fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                    //                           ? 10.0
                                                    //                           : 8.0,
                                                    //                     ),
                                                    //               ),
                                                    //             ],
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    // Padding(
                                                    //   padding:
                                                    //       EdgeInsetsDirectional
                                                    //           .fromSTEB(
                                                    //               0.0,
                                                    //               8.0,
                                                    //               0.0,
                                                    //               0.0),
                                                    //   child: Row(
                                                    //     mainAxisSize:
                                                    //         MainAxisSize.max,
                                                    //     crossAxisAlignment:
                                                    //         CrossAxisAlignment
                                                    //             .start,
                                                    //     children: [
                                                    //       Padding(
                                                    //         padding:
                                                    //             EdgeInsetsDirectional
                                                    //                 .fromSTEB(
                                                    //                     0.0,
                                                    //                     0.0,
                                                    //                     5.0,
                                                    //                     0.0),
                                                    //         child: Column(
                                                    //           mainAxisSize:
                                                    //               MainAxisSize
                                                    //                   .max,
                                                    //           children: [
                                                    //             Icon(
                                                    //               Icons
                                                    //                   .newspaper_sharp,
                                                    //               color: FlutterFlowTheme.of(
                                                    //                       context)
                                                    //                   .secondaryBackground,
                                                    //               size: 20.0,
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //       Column(
                                                    //         mainAxisSize:
                                                    //             MainAxisSize
                                                    //                 .max,
                                                    //         crossAxisAlignment:
                                                    //             CrossAxisAlignment
                                                    //                 .start,
                                                    //         children: [
                                                    //           Container(
                                                    //             width: MediaQuery.sizeOf(
                                                    //                         context)
                                                    //                     .width *
                                                    //                 0.25,
                                                    //             decoration:
                                                    //                 BoxDecoration(),
                                                    //             child: Text(
                                                    //               'ประกาศนโยบายเรื่องการคุ้มครองข้อมูลส่วนบุคคลของลูกค้าในระบบ...',
                                                    //               style: FlutterFlowTheme.of(
                                                    //                       context)
                                                    //                   .bodySmall
                                                    //                   .override(
                                                    //                     fontFamily:
                                                    //                         'Kanit',
                                                    //                     color: FlutterFlowTheme.of(context)
                                                    //                         .primaryBackground,
                                                    //                     fontSize: MediaQuery.sizeOf(context).width >=
                                                    //                             800.0
                                                    //                         ? 12.0
                                                    //                         : 10.0,
                                                    //                   ),
                                                    //             ),
                                                    //           ),
                                                    //           Row(
                                                    //             mainAxisSize:
                                                    //                 MainAxisSize
                                                    //                     .max,
                                                    //             children: [
                                                    //               Text(
                                                    //                 '09 พย 2566',
                                                    //                 style: FlutterFlowTheme.of(
                                                    //                         context)
                                                    //                     .bodySmall
                                                    //                     .override(
                                                    //                       fontFamily:
                                                    //                           'Kanit',
                                                    //                       color:
                                                    //                           FlutterFlowTheme.of(context).secondaryBackground,
                                                    //                       fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                    //                           ? 10.0
                                                    //                           : 8.0,
                                                    //                     ),
                                                    //               ),
                                                    //             ],
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    // Padding(
                                                    //   padding:
                                                    //       EdgeInsetsDirectional
                                                    //           .fromSTEB(
                                                    //               0.0,
                                                    //               8.0,
                                                    //               0.0,
                                                    //               0.0),
                                                    //   child: Row(
                                                    //     mainAxisSize:
                                                    //         MainAxisSize.max,
                                                    //     crossAxisAlignment:
                                                    //         CrossAxisAlignment
                                                    //             .start,
                                                    //     children: [
                                                    //       Padding(
                                                    //         padding:
                                                    //             EdgeInsetsDirectional
                                                    //                 .fromSTEB(
                                                    //                     0.0,
                                                    //                     0.0,
                                                    //                     5.0,
                                                    //                     0.0),
                                                    //         child: Column(
                                                    //           mainAxisSize:
                                                    //               MainAxisSize
                                                    //                   .max,
                                                    //           children: [
                                                    //             Icon(
                                                    //               Icons
                                                    //                   .newspaper_sharp,
                                                    //               color: FlutterFlowTheme.of(
                                                    //                       context)
                                                    //                   .secondaryBackground,
                                                    //               size: 20.0,
                                                    //             ),
                                                    //           ],
                                                    //         ),
                                                    //       ),
                                                    //       Column(
                                                    //         mainAxisSize:
                                                    //             MainAxisSize
                                                    //                 .max,
                                                    //         crossAxisAlignment:
                                                    //             CrossAxisAlignment
                                                    //                 .start,
                                                    //         children: [
                                                    //           Container(
                                                    //             width: MediaQuery.sizeOf(
                                                    //                         context)
                                                    //                     .width *
                                                    //                 0.25,
                                                    //             decoration:
                                                    //                 BoxDecoration(),
                                                    //             child: Text(
                                                    //               'ประกาศนโยบายเรื่องการคุ้มครองข้อมูลส่วนบุคคลของลูกค้าในระบบ...',
                                                    //               style: FlutterFlowTheme.of(
                                                    //                       context)
                                                    //                   .bodySmall
                                                    //                   .override(
                                                    //                     fontFamily:
                                                    //                         'Kanit',
                                                    //                     color: FlutterFlowTheme.of(context)
                                                    //                         .primaryBackground,
                                                    //                     fontSize: MediaQuery.sizeOf(context).width >=
                                                    //                             800.0
                                                    //                         ? 12.0
                                                    //                         : 10.0,
                                                    //                   ),
                                                    //             ),
                                                    //           ),
                                                    //           Row(
                                                    //             mainAxisSize:
                                                    //                 MainAxisSize
                                                    //                     .max,
                                                    //             children: [
                                                    //               Text(
                                                    //                 '09 พย 2566',
                                                    //                 style: FlutterFlowTheme.of(
                                                    //                         context)
                                                    //                     .bodySmall
                                                    //                     .override(
                                                    //                       fontFamily:
                                                    //                           'Kanit',
                                                    //                       color:
                                                    //                           FlutterFlowTheme.of(context).secondaryBackground,
                                                    //                       fontSize: MediaQuery.sizeOf(context).width >= 800.0
                                                    //                           ? 10.0
                                                    //                           : 8.0,
                                                    //                     ),
                                                    //               ),
                                                    //             ],
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: 100.0,
                            decoration: BoxDecoration(),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}

class PieChartExample extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  PieChartExample(this.seriesList, {this.animate = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 200,
      // height: 200,
      // padding: EdgeInsets.all(1.0),
      child: charts.PieChart<String>(
        seriesList,
        animate: animate,
        defaultRenderer: charts.ArcRendererConfig<String>(
          arcWidth: 60,
          arcRendererDecorators: [charts.ArcLabelDecorator()],
        ),
      ),
    );
  }
}

class SalesData {
  final String year;
  final int sales;

  SalesData(this.year, this.sales);
}

List<charts.Series<SalesData, String>> _createSampleData() {
  final data = [
    SalesData('now', 50),
    SalesData('befoer', 50),
    // SalesData('2019', 100),
    // SalesData('2020', 75),
  ];

  return [
    charts.Series<SalesData, String>(
      id: 'Sales',
      domainFn: (SalesData sales, _) => sales.year,
      measureFn: (SalesData sales, _) => sales.sales,
      data: data,
      // labelAccessorFn: (SalesData sales, _) => '${sales.year}: ${sales.sales}',
      labelAccessorFn: (SalesData sales, _) => '${sales.sales} %',
    )
  ];
}
