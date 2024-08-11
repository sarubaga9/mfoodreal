import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m_food/a01_home/a01_01_home/a0101_home_widget%20old.dart';
import 'package:m_food/a01_home/a01_05_dashboard/a0105_dashboard_widget.dart';
import 'package:m_food/a01_home/a01_05_dashboard/a0105_dashboard_widget_old.dart';
import 'package:m_food/main3333.dart';
import 'package:m_food/nav_bar_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '/index.dart';
import '../../main_old.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => NavBarPage(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => NavBarPage(),
        ),
        FFRoute(
          name: 'A01_01_Home',
          path: '/a0101Home',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'A01_01_Home')
              : A0101HomeWidgetOld(),
        ),
        FFRoute(
          name: 'A02_01_Favorite',
          path: '/a0201Favorite',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'A02_01_Favorite')
              : A0201FavoriteWidget(),
        ),
        FFRoute(
          name: 'A03_01_Chat',
          path: '/a0301Chat',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'A03_01_Chat')
              : A0301ChatWidget(),
        ),
        FFRoute(
          name: 'A04_01_ListOrder',
          path: '/a0401ListOrder',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'A04_01_ListOrder')
              : A0401ListOrderWidget(),
        ),
        FFRoute(
          name: 'A05_01_MoneyTransfer',
          path: '/a0501MoneyTransfer',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0501MoneyTransferWidget(),
          ),
        ),
        FFRoute(
          name: 'A06_01_Setting',
          path: '/a0601Setting',
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'A06_01_Setting')
              : NavBarPage(
                  initialPage: 'A06_01_Setting',
                  page: A0601SettingWidget(),
                ),
        ),
        FFRoute(
          name: 'A01_02_Login',
          path: '/a0102Login',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0102LoginWidget(),
          ),
        ),
        FFRoute(
          name: 'A01_03_Register',
          path: '/a0103Register',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0103RegisterWidget(),
          ),
        ),
        FFRoute(
          name: 'A01_04_DataTransfer',
          path: '/a0104DataTransfer',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0104DataTransferWidget(),
          ),
        ),
        FFRoute(
          name: 'A01_05_Dashboard',
          path: '/a0105Dashboard',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0105DashboardWidget(),
          ),
        ),
        FFRoute(
          name: 'A01_06_OTP',
          path: '/a0106Otp',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0106OtpWidget(),
          ),
        ),
        FFRoute(
          name: 'A01_07_PasswordReset',
          path: '/a0107PasswordReset',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0107PasswordResetWidget(),
          ),
        ),
        FFRoute(
          name: 'A07_01_OpenAccount',
          path: '/a0701OpenAccount',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0701OpenAccountWidget(),
          ),
        ),
        FFRoute(
          name: 'A01_08_Product',
          path: '/a0108Product',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0108ProductWidget(),
          ),
        ),
        FFRoute(
          name: 'A01_01_ProductPic',
          path: '/a0101ProductPic',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0101ProductPicWidget(),
          ),
        ),
        FFRoute(
          name: 'A01_01_HomeCopy',
          path: '/a0101HomeCopy',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0101HomeCopyWidget(),
          ),
        ),
        FFRoute(
          name: 'A01_04_DataTransferCopy',
          path: '/a0104DataTransferCopy',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0104DataTransferCopyWidget(),
          ),
        ),
        FFRoute(
          name: 'A07_03_UserGeneral',
          path: '/a0703UserGeneral',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0703UserGeneralWidget(),
          ),
        ),
        FFRoute(
          name: 'A07_02_OpenAccount',
          path: '/a0702OpenAccount',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0702OpenAccountWidget(),
          ),
        ),
        FFRoute(
          name: 'A07_04_UserGeneralSuccess',
          path: '/a0704UserGeneralSuccess',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0704UserGeneralSuccessWidget(),
          ),
        ),
        FFRoute(
          name: 'A07_05_OpenAccountCopy',
          path: '/a0705OpenAccountCopy',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0705OpenAccountCopyWidget(),
          ),
        ),
        FFRoute(
          name: 'A07_06_UserLegalEntity',
          path: '/a0706UserLegalEntity',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0706UserLegalEntityWidget(),
          ),
        ),
        FFRoute(
          name: 'A07_07_UserLegalEntitySuccess',
          path: '/a0707UserLegalEntitySuccess',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0707UserLegalEntitySuccessWidget(),
          ),
        ),
        FFRoute(
          name: 'A07_08_ListOpened',
          path: '/a0708ListOpened',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0708ListOpenedWidget(),
          ),
        ),
        FFRoute(
          name: 'A07_10_Save',
          path: '/a0710Save',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0710SaveWidget(),
          ),
        ),
        FFRoute(
          name: 'A07_11_ListSave',
          path: '/a0711ListSave',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0711ListSaveWidget(),
          ),
        ),
        FFRoute(
          name: 'A07_12_UserGeneralEdit',
          path: '/a0712UserGeneralEdit',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0712UserGeneralEditWidget(),
          ),
        ),
        FFRoute(
          name: 'A07_13_Accept',
          path: '/a0713Accept',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0713AcceptWidget(),
          ),
        ),
        FFRoute(
          name: 'A07_09_step',
          path: '/a0709Step',
          builder: (context, params) => NavBarPage(
            initialPage: '',
            page: A0709StepWidget(),
          ),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      !state.allParams.isNotEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).transitionsBuilder,
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouter.of(context).location;
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}
