import 'package:PrimeTasche/page/kurye/kurye_sec_page.dart';
import 'package:PrimeTasche/page/qr_islem_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:PrimeTasche/page/admin_home_page.dart';
import 'package:PrimeTasche/page/admin_map_page.dart';
import 'package:PrimeTasche/page/canta_add_page.dart';
import 'package:PrimeTasche/page/canta_list_page.dart';
import 'package:PrimeTasche/page/canta_teslim_al_page.dart';
import 'package:PrimeTasche/page/canta_teslim_et_page.dart';
import 'package:PrimeTasche/page/kurye/kurye_map.dart';
import 'package:PrimeTasche/page/kurye/kurye_add_page.dart';
import 'package:PrimeTasche/page/kurye/kurye_home_page.dart';
import 'package:PrimeTasche/page/kurye/kurye_list_page.dart';
import 'package:PrimeTasche/page/login_page.dart';
import 'package:PrimeTasche/page/map.dart';
import 'package:PrimeTasche/page/qr_camera_page.dart';
import 'package:PrimeTasche/page/select_account_page.dart';
import 'package:PrimeTasche/page/splash_page.dart';
import 'package:PrimeTasche/page/teslimat_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter routes = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: "/",
  routes: [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/',
      builder: (context, state) {
        return const SplashPage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/adminhome',
      builder: (context, state) {
        return const AdminHomePage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/bagadd',
      builder: (context, state) {
        return const BagAddPage();
      },
    ),
     GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/kuryesec',
      builder: (context, state) {
        return const KuryeSecPage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/kuryeadd',
      builder: (context, state) {
        return const KuryeAddPage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/kuryelist',
      builder: (context, state) {
        return const KuryeListPage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/baglist',
      builder: (context, state) {
        return const BagListPage();
      },
    ),
     GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/qrislem',
      builder: (context, state) {
        return const QrIslemPage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/qrcamera',
      builder: (context, state) {
        return const QrCameraPage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/accountselect',
      builder: (context, state) {
        return const AccountSelectPage(
          title: "Giriş",
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/mappage',
      builder: (context, state) {
        return const MapPage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/teslimat',
      builder: (context, state) {
        return const TeslimatListPage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/adminmappage',
      builder: (context, state) {
        return const AdminMapPage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/home',
      builder: (context, state) {
        return const KuryeHomePage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/kuryemap',
      builder: (context, state) {
        return const KuryeMap();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/cantateslimet',
      builder: (context, state) {
        return const CantaTeslimEtPage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/cantateslimal',
      builder: (context, state) {
        return const CantaTeslimAlPage();
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/login',
      builder: (context, state) {
        return const LoginPage();
      },
    ),
  ],
);

extension GoRouterLocation on GoRouter {
  String get location {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList =
        lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}

final routeProvider = Provider<GoRouter>((ref) => routes);
