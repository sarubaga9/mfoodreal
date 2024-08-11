import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_food/a01_home/a01_01_home/a0101_home_widget.dart';
import 'package:m_food/a01_home/a01_03_register/a0103_register_widget%20copy.dart';
import 'package:m_food/a01_home/a01_04_data_transfer_copy/a0104_data_transfer_copy_widget.dart';
import 'package:m_food/index.dart';
import '/color_detail_page.dart';
import '/colors_list_page.dart';
import '/tab_item.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String favorite = '/favorite';
  static const String contract = '/contract';
  static const String cart = '/cart';
  static const String pay = '/pay';
  static const String setting = '/setting';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator(
      {super.key, required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItem tabItem;

  void _push(BuildContext context, {int materialIndex = 500}) {
    var routeBuilders = _routeBuilders(context, materialIndex: materialIndex);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            routeBuilders[TabNavigatorRoutes.favorite]!(context),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context,
      {int materialIndex = 500}) {
    return {
      TabNavigatorRoutes.root: (context) => A0101HomeWidget(),
      TabNavigatorRoutes.favorite: (context) => Container(),
      TabNavigatorRoutes.contract: (context) => Container(),
      TabNavigatorRoutes.cart: (context) => Container(),
      TabNavigatorRoutes.pay: (context) => Container(),
      TabNavigatorRoutes.setting: (context) => Container(),
      // TabNavigatorRoutes.root: (context) => ColorsListPage(
      //       color: tabItem.color,
      //       title: tabItem.name,
      //       onPush: (materialIndex) =>
      //           _push(context, materialIndex: materialIndex),
      //     ),
      // TabNavigatorRoutes.detail: (context) => ColorDetailPage(
      //       color: tabItem.color,
      //       title: tabItem.name,
      //       materialIndex: materialIndex,
      //     ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    // print('object333');
    // print(tabItem);
    // print(routeBuilders);
    // print(navigatorKey);
    String page = '';
    tabItem == TabItem.home
        ? page = '/'
        : tabItem == TabItem.favorite
            ? page = '/favorite'
            : tabItem == TabItem.contract
                ? page = '/contract'
                : tabItem == TabItem.cart
                    ? page = '/cart'
                    : tabItem == TabItem.pay
                        ? page = '/pay'
                        : page = '/setting';

    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        // print(routeSettings.name);
        return MaterialPageRoute(
          builder: (context) => routeBuilders[page]!(context),
        );
      },
    );
  }
}
