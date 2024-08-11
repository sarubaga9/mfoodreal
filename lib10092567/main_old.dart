// import 'package:provider/provider.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_web_plugins/url_strategy.dart';
// import 'flutter_flow/flutter_flow_theme.dart';
// import 'flutter_flow/flutter_flow_util.dart';
// import 'flutter_flow/internationalization.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
// import 'flutter_flow/nav/nav.dart';
// import 'index.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   usePathUrlStrategy();

//   final appState = FFAppState(); // Initialize FFAppState
//   await appState.initializePersistedState();

//   runApp(ChangeNotifierProvider(
//     create: (context) => appState,
//     child: MyApp(),
//   ));
// }

// class MyApp extends StatefulWidget {
//   // This widget is the root of your application.
//   @override
//   State<MyApp> createState() => _MyAppState();

//   static _MyAppState of(BuildContext context) =>
//       context.findAncestorStateOfType<_MyAppState>()!;
// }

// class _MyAppState extends State<MyApp> {
//   Locale? _locale;
//   ThemeMode _themeMode = ThemeMode.system;

//   late AppStateNotifier _appStateNotifier;
//   late GoRouter _router;

//   @override
//   void initState() {
//     super.initState();

//     _appStateNotifier = AppStateNotifier.instance;
//     _router = createRouter(_appStateNotifier);
//   }

//   void setLocale(String language) {
//     setState(() => _locale = createLocale(language));
//   }

//   void setThemeMode(ThemeMode mode) => setState(() {
//         _themeMode = mode;
//       });

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'M-Food',
//       localizationsDelegates: [
//         FFLocalizationsDelegate(),
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       locale: _locale,
//       supportedLocales: const [Locale('en', '')],
//       theme: ThemeData(
//         brightness: Brightness.light,
//         scrollbarTheme: ScrollbarThemeData(),
//       ),
//       themeMode: _themeMode,
//       routerConfig: _router,
//     );
//   }
// }

// class NavBarPage extends StatefulWidget {
//   NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);

//   final String? initialPage;
//   final Widget? page;

//   @override
//   _NavBarPageState createState() => _NavBarPageState();
// }

// /// This is the private State class that goes with NavBarPage.
// class _NavBarPageState extends State<NavBarPage> {
//   String _currentPageName = 'A01_01_Home';
//   late Widget? _currentPage;

//   @override
//   void initState() {
//     super.initState();
//     _currentPageName = widget.initialPage ?? _currentPageName;
//     _currentPage = widget.page;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tabs = {
//       'A01_01_Home': A0101HomeWidget(),
//       'A02_01_Favorite': A0201FavoriteWidget(),
//       'A03_01_Chat': A0301ChatWidget(),
//       'A04_01_ListOrder': A0401ListOrderWidget(),
//       'A06_01_Setting': A0601SettingWidget(),
//     };
//     final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

//     final MediaQueryData queryData = MediaQuery.of(context);

//     return Scaffold(
//       body: MediaQuery(
//           data: queryData
//               .removeViewInsets(removeBottom: true)
//               .removeViewPadding(removeBottom: true),
//           child: _currentPage ?? tabs[_currentPageName]!),
//       extendBody: true,
//       bottomNavigationBar: FloatingNavbar(
//         currentIndex: currentIndex,
//         onTap: (i) => setState(() {
//           _currentPage = null;
//           _currentPageName = tabs.keys.toList()[i];
//         }),
//         backgroundColor: FlutterFlowTheme.of(context).alternate,
//         selectedItemColor: FlutterFlowTheme.of(context).primaryBackground,
//         unselectedItemColor: FlutterFlowTheme.of(context).secondaryBackground,
//         selectedBackgroundColor: Color(0x00000000),
//         borderRadius: 0.0,
//         itemBorderRadius: 8.0,
//         margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
//         padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
//         width: double.infinity,
//         elevation: 0.0,
//         items: [
//           FloatingNavbarItem(
//             customWidget: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   currentIndex == 0 ? Icons.home_sharp : Icons.home_sharp,
//                   color: currentIndex == 0
//                       ? FlutterFlowTheme.of(context).primaryBackground
//                       : FlutterFlowTheme.of(context).secondaryBackground,
//                   size: currentIndex == 0 ? 32.0 : 30.0,
//                 ),
//                 Text(
//                   'หน้าหลัก',
//                   overflow: TextOverflow.ellipsis,
//                   style: FlutterFlowTheme.of(context).bodySmall.override(
//                         fontFamily: 'Kanit',
//                         color: FlutterFlowTheme.of(context).secondaryBackground,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           FloatingNavbarItem(
//             customWidget: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   currentIndex == 1
//                       ? Icons.favorite_sharp
//                       : Icons.favorite_sharp,
//                   color: currentIndex == 1
//                       ? FlutterFlowTheme.of(context).primaryBackground
//                       : FlutterFlowTheme.of(context).secondaryBackground,
//                   size: currentIndex == 1 ? 32.0 : 30.0,
//                 ),
//                 Text(
//                   'สั่งประจำ',
//                   overflow: TextOverflow.ellipsis,
//                   style: FlutterFlowTheme.of(context).bodySmall.override(
//                         fontFamily: 'Kanit',
//                         color: FlutterFlowTheme.of(context).secondaryBackground,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           FloatingNavbarItem(
//             customWidget: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   currentIndex == 2 ? Icons.email_sharp : Icons.email_sharp,
//                   color: currentIndex == 2
//                       ? FlutterFlowTheme.of(context).primaryBackground
//                       : FlutterFlowTheme.of(context).secondaryBackground,
//                   size: currentIndex == 2 ? 32.0 : 30.0,
//                 ),
//                 Text(
//                   'แช็ทคุยกับเรา',
//                   overflow: TextOverflow.ellipsis,
//                   style: FlutterFlowTheme.of(context).bodySmall.override(
//                         fontFamily: 'Kanit',
//                         color: FlutterFlowTheme.of(context).secondaryBackground,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           FloatingNavbarItem(
//             customWidget: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   currentIndex == 3
//                       ? Icons.shopping_basket_sharp
//                       : Icons.shopping_basket_sharp,
//                   color: currentIndex == 3
//                       ? FlutterFlowTheme.of(context).primaryBackground
//                       : FlutterFlowTheme.of(context).secondaryBackground,
//                   size: currentIndex == 3 ? 32.0 : 30.0,
//                 ),
//                 Text(
//                   'รายการสั่งชื้อ',
//                   overflow: TextOverflow.ellipsis,
//                   style: FlutterFlowTheme.of(context).bodySmall.override(
//                         fontFamily: 'Kanit',
//                         color: FlutterFlowTheme.of(context).secondaryBackground,
//                       ),
//                 ),
//               ],
//             ),
//           ),
//           FloatingNavbarItem(
//             customWidget: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   currentIndex == 4
//                       ? Icons.settings_sharp
//                       : Icons.settings_sharp,
//                   color: currentIndex == 4
//                       ? FlutterFlowTheme.of(context).primaryBackground
//                       : FlutterFlowTheme.of(context).secondaryBackground,
//                   size: currentIndex == 4 ? 32.0 : 30.0,
//                 ),
//                 Text(
//                   'การตั้งค่า',
//                   overflow: TextOverflow.ellipsis,
//                   style: FlutterFlowTheme.of(context).bodySmall.override(
//                         fontFamily: 'Kanit',
//                         color: FlutterFlowTheme.of(context).secondaryBackground,
//                       ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<_HomeScreenState> navBarKey = GlobalKey<_HomeScreenState>();
//   int currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => OtherScreen(navBarKey: navBarKey),
//               ),
//             );
//           },
//           child: Text('Go to Other'),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         onTap: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.star),
//             label: 'Other',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class OtherScreen extends StatelessWidget {
//   final GlobalKey<_HomeScreenState> navBarKey;

//   const OtherScreen({Key? key, required this.navBarKey}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Other Screen'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => AnotherScreen(navBarKey: navBarKey),
//               ),
//             );
//           },
//           child: Text('Go to Another'),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: navBarKey.currentState?.currentIndex ?? 0,
//         onTap: (index) {
//           navBarKey.currentState?.setState(() {
//             navBarKey.currentState?.currentIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.star),
//             label: 'Other',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AnotherScreen extends StatelessWidget {
//   final GlobalKey<_HomeScreenState> navBarKey;

//   const AnotherScreen({Key? key, required this.navBarKey}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Another Screen'),
//       ),
//       body: Center(
//         child: Text('This is another screen'),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: navBarKey.currentState?.currentIndex ?? 0,
//         onTap: (index) {
//           navBarKey.currentState?.setState(() {
//             navBarKey.currentState?.currentIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.star),
//             label: 'Other',
//           ),
//         ],
//       ),
//     );
//   }
// }
