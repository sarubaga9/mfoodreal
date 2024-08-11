import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:m_food/flutter_flow/flutter_flow_theme.dart';
import '/tab_item.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation(
      {super.key, required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: FlutterFlowTheme.of(context).alternate,
      unselectedLabelStyle: FlutterFlowTheme.of(context).bodySmall.override(
            fontFamily: 'Kanit',
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
      selectedLabelStyle: FlutterFlowTheme.of(context).bodySmall.override(
            fontFamily: 'Kanit',
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.home_sharp,
            color: FlutterFlowTheme.of(context).primaryBackground,
            // color: Colors.amber,
            size: 32.0,
          ),
          icon: Icon(
            Icons.home_sharp,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            // color: Colors.green,
            size: 30.0,
          ),
          label: 'หน้าหลัก',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.favorite_sharp,
            color: FlutterFlowTheme.of(context).primaryBackground,
            // color: Colors.amber,
            size: 32.0,
          ),
          icon: Icon(
            Icons.favorite_sharp,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            // color: Colors.green,
            size: 30.0,
          ),
          label: 'สั่งประจำ',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.email_sharp,
            color: FlutterFlowTheme.of(context).primaryBackground,
            // color: Colors.amber,
            size: 32.0,
          ),
          icon: Icon(
            Icons.email_sharp,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            // color: Colors.green,
            size: 30.0,
          ),
          label: 'แช็ทคุยกับเรา',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.shopping_basket_sharp,
            color: FlutterFlowTheme.of(context).primaryBackground,
            // color: Colors.amber,
            size: 32.0,
          ),
          icon: Icon(
            Icons.shopping_basket_sharp,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            // color: Colors.green,
            size: 30.0,
          ),
          label: 'รายการสั่งชื้อ',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.payments,
            color: FlutterFlowTheme.of(context).primaryBackground,
            // color: Colors.amber,
            size: 32.0,
          ),
          icon: Icon(
            Icons.payments,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            // color: Colors.green,
            size: 30.0,
          ),
          label: 'แจ้งการโอนเงิน',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(
            Icons.settings_sharp,
            color: FlutterFlowTheme.of(context).primaryBackground,
            // color: Colors.amber,
            size: 32.0,
          ),
          icon: Icon(
            Icons.settings_sharp,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            // color: Colors.green,
            size: 30.0,
          ),
          label: 'การตั้งค่า',
        ),

        // _buildItem(TabItem.red),
        // _buildItem(TabItem.green),
        // _buildItem(TabItem.blue),
        // _buildItem(TabItem.red),
        // _buildItem(TabItem.green),
        // _buildItem(TabItem.blue),
      ],
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
      currentIndex: currentTab.index,
      selectedItemColor: FlutterFlowTheme.of(context).primaryBackground,
      unselectedItemColor: FlutterFlowTheme.of(context).secondaryBackground,
    );
  }

  // BottomNavigationBarItem _buildItem(TabItem tabItem) {
  //   return BottomNavigationBarItem(
  //     icon: Icon(
  //       Icons.layers,
  //       color: _colorTabMatching(tabItem),
  //     ),
  //     label: tabItem.name,
  //   );
  // }

  // Color _colorTabMatching(TabItem item) {
  //   return currentTab == item ? item.color : Colors.grey;
  // }
}
