import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:m_food/a01_home/a01_01_home/a0101_home_widget.dart';
import 'package:m_food/app.dart';
import 'package:m_food/bottom_navigation.dart';
import 'package:m_food/controller/category_product_controller.dart';
import 'package:m_food/controller/customer_controller.dart';
import 'package:m_food/controller/dynamic_link.dart';
import 'package:m_food/controller/news_controller.dart';
import 'package:m_food/controller/shared_preference_controller.dart';
import 'package:m_food/controller/user_controller.dart';
import 'package:m_food/flutter_flow/flutter_flow_theme.dart';
import 'package:m_food/flutter_flow/flutter_flow_util.dart';
import 'package:m_food/flutter_flow/internationalization.dart';
import 'package:m_food/index.dart';
import 'package:m_food/main3333.dart';
import 'package:m_food/main_old.dart';
import 'package:m_food/tab_item.dart';
import 'package:m_food/tab_navigator.dart';
import 'package:m_food/widgets/circular_loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NavBarPage extends StatefulWidget {
  final String? initialPage;
  final Widget? page;

  const NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'A01_01_Home';
  late Widget? _currentPage;

  final GlobalKey<_NavBarPageState> navBarKey = GlobalKey<_NavBarPageState>();

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  var _currentTab = TabItem.home;

  final _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.favorite: GlobalKey<NavigatorState>(),
    TabItem.contract: GlobalKey<NavigatorState>(),
    TabItem.cart: GlobalKey<NavigatorState>(),
    TabItem.pay: GlobalKey<NavigatorState>(),
    TabItem.setting: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    // print(tabItem);
    // print(_currentTab);
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      // 'A01_01_Home': A0101HomeWidget(),
      // 'A02_01_Favorite': A0201FavoriteWidget(),
      // 'A03_01_Chat': A0301ChatWidget(),
      // 'A04_01_ListOrder': A0401ListOrderWidget(),
      // 'A06_01_Setting': A0601SettingWidget(),
      'A01_01_Home': A0101HomeWidget(),
      'A02_01_Favorite': Container(),
      'A03_01_Chat': Container(),
      'A04_01_ListOrder': Container(),
      'A06_01_Setting': Container(),
    };

    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    final MediaQueryData queryData = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentTab != TabItem.home) {
            _selectTab(TabItem.home);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        // appBar: AppBar( ),
        // body: MediaQuery(
        //   data: queryData
        //       .removeViewInsets(removeBottom: true)
        //       .removeViewPadding(removeBottom: true),
        //   child: _currentPage ?? tabs[_currentPageName]!,
        // ),
        body:
            // Stack(children: <Widget>[
            _currentTab == TabItem.home
                ? _buildOffstageNavigator(TabItem.home)
                : _currentTab == TabItem.favorite
                    ? _buildOffstageNavigator(TabItem.favorite)
                    : _currentTab == TabItem.contract
                        ? _buildOffstageNavigator(TabItem.contract)
                        : _currentTab == TabItem.cart
                            ? _buildOffstageNavigator(TabItem.cart)
                            : _currentTab == TabItem.pay
                                ? _buildOffstageNavigator(TabItem.pay)
                                : _buildOffstageNavigator(TabItem.setting),
        // SafeArea(
        //   child: Container(
        //     child: Column(
        //       children: [
        //         SizedBox(height: 1000,),
        //         Text('fdsfsdjfkldmsjkfdsjkfdsmf'),
        //       ],
        //     ),
        //   ),
        // ),
        // _buildOffstageNavigator(TabItem.contract),
        // _buildOffstageNavigator(TabItem.cart),
        // _buildOffstageNavigator(TabItem.pay),
        // _buildOffstageNavigator(TabItem.setting),
        // ]),
        extendBody: true,
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),

        //  FloatingNavbar(
        //   currentIndex: currentIndex,
        //   onTap: (i) => setState(() {
        //     _currentPage = null;
        //     _currentPageName = tabs.keys.toList()[i];
        //   }),
        //   backgroundColor: FlutterFlowTheme.of(context).alternate,
        //   selectedItemColor: FlutterFlowTheme.of(context).primaryBackground,
        //   unselectedItemColor: FlutterFlowTheme.of(context).secondaryBackground,
        //   selectedBackgroundColor: Color(0x00000000),
        //   borderRadius: 0.0,
        //   itemBorderRadius: 8.0,
        //   margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        //   padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
        //   width: double.infinity,
        //   elevation: 0.0,
        //   items: [
        //     FloatingNavbarItem(
        //       customWidget: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Icon(
        //             currentIndex == 0 ? Icons.home_sharp : Icons.home_sharp,
        //             color: currentIndex == 0
        //                 ? FlutterFlowTheme.of(context).primaryBackground
        //                 : FlutterFlowTheme.of(context).secondaryBackground,
        //             size: currentIndex == 0 ? 32.0 : 30.0,
        //           ),
        //           Text(
        //             'หน้าหลัก',
        //             overflow: TextOverflow.ellipsis,
        //             style: FlutterFlowTheme.of(context).bodySmall.override(
        //                   fontFamily: 'Kanit',
        //                   color:
        //                       FlutterFlowTheme.of(context).secondaryBackground,
        //                 ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     FloatingNavbarItem(
        //       customWidget: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Icon(
        //             currentIndex == 1
        //                 ? Icons.favorite_sharp
        //                 : Icons.favorite_sharp,
        //             color: currentIndex == 1
        //                 ? FlutterFlowTheme.of(context).primaryBackground
        //                 : FlutterFlowTheme.of(context).secondaryBackground,
        //             size: currentIndex == 1 ? 32.0 : 30.0,
        //           ),
        //           Text(
        //             'สั่งประจำ',
        //             overflow: TextOverflow.ellipsis,
        //             style: FlutterFlowTheme.of(context).bodySmall.override(
        //                   fontFamily: 'Kanit',
        //                   color:
        //                       FlutterFlowTheme.of(context).secondaryBackground,
        //                 ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     FloatingNavbarItem(
        //       customWidget: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Icon(
        //             currentIndex == 2 ? Icons.email_sharp : Icons.email_sharp,
        //             color: currentIndex == 2
        //                 ? FlutterFlowTheme.of(context).primaryBackground
        //                 : FlutterFlowTheme.of(context).secondaryBackground,
        //             size: currentIndex == 2 ? 32.0 : 30.0,
        //           ),
        //           Text(
        //             'แช็ทคุยกับเรา',
        //             overflow: TextOverflow.ellipsis,
        //             style: FlutterFlowTheme.of(context).bodySmall.override(
        //                   fontFamily: 'Kanit',
        //                   color:
        //                       FlutterFlowTheme.of(context).secondaryBackground,
        //                 ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     FloatingNavbarItem(
        //       customWidget: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Icon(
        //             currentIndex == 3
        //                 ? Icons.shopping_basket_sharp
        //                 : Icons.shopping_basket_sharp,
        //             color: currentIndex == 3
        //                 ? FlutterFlowTheme.of(context).primaryBackground
        //                 : FlutterFlowTheme.of(context).secondaryBackground,
        //             size: currentIndex == 3 ? 32.0 : 30.0,
        //           ),
        //           Text(
        //             'รายการสั่งชื้อ',
        //             overflow: TextOverflow.ellipsis,
        //             style: FlutterFlowTheme.of(context).bodySmall.override(
        //                   fontFamily: 'Kanit',
        //                   color:
        //                       FlutterFlowTheme.of(context).secondaryBackground,
        //                 ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     FloatingNavbarItem(
        //       customWidget: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Icon(
        //             currentIndex == 4
        //                 ? Icons.settings_sharp
        //                 : Icons.settings_sharp,
        //             color: currentIndex == 4
        //                 ? FlutterFlowTheme.of(context).primaryBackground
        //                 : FlutterFlowTheme.of(context).secondaryBackground,
        //             size: currentIndex == 4 ? 32.0 : 30.0,
        //           ),
        //           Text(
        //             'การตั้งค่า',
        //             overflow: TextOverflow.ellipsis,
        //             style: FlutterFlowTheme.of(context).bodySmall.override(
        //                   fontFamily: 'Kanit',
        //                   color:
        //                       FlutterFlowTheme.of(context).secondaryBackground,
        //                 ),
        //           ),
        //         ],
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }
}
