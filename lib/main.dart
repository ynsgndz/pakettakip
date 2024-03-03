import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:PrimeTasche/controller/canta_list_controller.dart';
import 'package:PrimeTasche/controller/connection_controller.dart';
import 'package:PrimeTasche/controller/kurye_controller.dart';
import 'package:PrimeTasche/firebase_options.dart';
import 'package:PrimeTasche/route_provider.dart';
import 'package:riverpod_context/riverpod_context.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:get_storage/get_storage.dart';
import 'package:PrimeTasche/controller/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterMapTileCaching.initialise();
  await FMTC.instance('mapStore').manage.createAsync();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  var storage = GetStorage();
  if (storage.hasData("lang")) {
    if (storage.read("lang")) {
      container.read(languageProvider).english();
    } else {
      container.read(languageProvider).german();
    }
  }
  final connectedRef = FirebaseDatabase.instance.ref(".info/connected");
  connectedRef.onValue.listen((event) {
    final connected = event.snapshot.value as bool? ?? false;
    if (connected) {
      container.read(connectionProvider).changeConnectionState(true);
    } else {
      debugPrint("Not connected.");
      container.read(connectionProvider).changeConnectionState(false);
    }
  });

  runApp(const ProviderScope(child: MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

final container = ProviderContainer(overrides: []);
late FirebaseAuth auth;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(104857599);
    auth = FirebaseAuth.instance;
    final cantalar = FirebaseDatabase.instance.ref("cantalar");
    cantalar.keepSynced(true);

    auth.authStateChanges().listen((User? user) {
      print(user?.email ?? "nullmuş");
      if (user == null) {
        if (context.read(routeProvider).location != "/" && context.read(routeProvider).location != "/accountselect") {
          context.read(routeProvider).go("/login");
        }
      } else {
        context.read(bagListProvider).getCantalar();
        if (user.uid == "KgudjIDXmtdp3zke7WWANtbRXUv1") {
          context.read(kuryeListProvider).getKurye();
          context.read(routeProvider).go("/adminhome");
          user.updateDisplayName("Admin");
        } else {
          context.read(routeProvider).go("/home");
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        if (context.read(routeProvider).location == "/") {
          context.read(routeProvider).go("/accountselect");
        }
      });
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return UncontrolledProviderScope(
      container: container,
      child: OverlaySupport.global(
        child: MaterialApp.router(
          key: navigatorKey,
          routerConfig: context.read(routeProvider),
          title: 'Çanta Takip',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
            textTheme: GoogleFonts.openSansTextTheme(textTheme).copyWith(
              bodyMedium: GoogleFonts.openSans(textStyle: textTheme.bodyMedium),
            ),
          ),
        ),
      ),
    );
  }
}
