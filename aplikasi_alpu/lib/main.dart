import 'package:alpu_pbl/pasien/pencarian_dokter.dart';
import 'package:alpu_pbl/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pasien/home.dart';
import 'pasien/info.dart' as Pasien;
import 'splash.dart';
import 'login.dart';
import 'pasien/jadwal.dart';
import 'admin/konfirmasi.dart';
import 'pasien/home_awal.dart';
import 'pasien/formulir.dart';
import 'admin/home_admin.dart';
import 'admin/kelola_pasien.dart';
import 'admin/kelola_dokter.dart';
import 'admin/kelola_jadwal.dart';
import 'admin/kelola_poliklinik.dart' as Admin;
import 'package:flutter_localizations/flutter_localizations.dart';

const baseUrl = "http://192.168.9.64";
//api ngrok windows
// const baseUrl = "https://afc8-182-2-6-158.ngrok-free.app";
//api ngrok linux
// const baseUrl = "https://b9f8-182-2-6-230.ngrok-free.app";

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting("in_ID");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('in_ID')],
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi ALPU',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme:
              const AppBarTheme().copyWith(foregroundColor: Colors.white),
          elevatedButtonTheme: const ElevatedButtonThemeData(
              style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(Colors.white),
            backgroundColor: MaterialStatePropertyAll(
              Color.fromARGB(255, 8, 90, 132),
            ),
          ))),
      navigatorKey: navigatorKey,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashPage(),
        '/pasien/home': (context) => HomePage(),
        '/pasien/home_awal': (context) => HomeAwal(),
        '/pasien/info': (context) => Pasien.InfoPage(),
        '/login': (context) => const LoginPage(),
        '/pasien/pencarian_dokter': (context) => PencarianDokterPage(),
        '/pasien/jadwal': (context) => JadwalPage(),
        '/pasien/formulir': (context) => FormulirPage(),
        '/admin/home_admin': (context) => HomeAdminPage(),
        '/admin/konfirmasi': (context) => const KehadiranPage(),
        '/admin/kelola_pasien': (context) => KelolaPasienPage(),
        '/admin/kelola_dokter': (context) => KelolaDokterPage(),
        '/admin/kelola_poliklinik': (context) =>
            const Admin.KelolaPoliklinikPage(),
        '/admin/kelola_jadwal': (context) => KelolaJadwalDokterPage(),
        '/user_profile': (context) => const ProfileUser(),
      },
    );
  }
}
