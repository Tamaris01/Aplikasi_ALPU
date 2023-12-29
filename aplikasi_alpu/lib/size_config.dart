import 'package:alpu_pbl/pasien/pencarian_dokter.dart';
import 'package:alpu_pbl/user_profile.dart';
import 'package:alpu_pbl/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'pasien/home.dart';
import 'pasien/info.dart' as Pasien;
import 'splash.dart';
import 'login.dart';
import 'pasien/jadwal.dart';
import 'pasien/home_awal.dart';
import 'pasien/formulir.dart';
import 'admin/home_admin.dart';
import 'admin/kelola_pasien.dart';
import 'admin/kelola_dokter.dart';
import 'admin/kelola_jadwal.dart';
import 'admin/kelola_poliklinik.dart' as Admin;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

GetIt locator = GetIt.instance;

Future setupLocator() async {
  PreferencesUtil? util = await PreferencesUtil.getInstance();
  locator.registerSingleton<PreferencesUtil>(util!);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi ALPU',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashPage(),
        '/pasien/home': (context) => HomePage(),
        '/pasien/home_awal': (context) => HomeAwal(),
        '/pasien/info': (context) => Pasien.InfoPage(),
        '/login': (context) => LoginPage(),
        '/pasien/pencarian_dokter': (context) => PencarianDokterPage(),
        '/pasien/jadwal': (context) => JadwalPage(),
        '/pasien/formulir': (context) => FormulirPage(),
        '/admin/home_admin': (context) => HomeAdminPage(),
        '/admin/kelola_pasien': (context) => KelolaPasienPage(),
        '/admin/kelola_dokter': (context) => KelolaDokterPage(),
        '/admin/kelola_poliklinik': (context) => Admin.KelolaPoliklinikPage(),
        '/admin/kelola_jadwal': (context) => KelolaJadwalDokterPage(),
        '/user_profile': (context) => ProfileUser(),
      },
    );
  }
}
