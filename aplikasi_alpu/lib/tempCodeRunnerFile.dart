import 'package:alpu_pbl/pasien/pencarian_dokter.dart';
import 'package:alpu_pbl/user_profile.dart';

import 'package:flutter/material.dart';
import 'pasien/home.dart';
import 'pasien/info.dart';
import 'splash.dart';
import 'login.dart';
import 'pasien/jadwal.dart';
import 'pasien/formulir.dart';
import 'admin/home_admin.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Saya',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      initialRoute: '/splash', // Set rute awal ke SplashPage
      routes: {
        '/splash': (context) => SplashPage(),
        '/pasien/home': (context) => HomePage(),
        '/admin/home_admin': (context) => HomeAdminPage(),
        '/pasien/info': (context) => InfoPage(),
        '/login': (context) => LoginPage(),
        '/pasien/pencarian_dokter': (context) => PencarianDokterPage(),
        '/pasien/jadwal': (context) => JadwalPage(),
        '/pasien/formulir': (context) => FormulirPage(),
        '/user_profile': (context) => ProfileUser(),
     
      },
    );
  }
}
