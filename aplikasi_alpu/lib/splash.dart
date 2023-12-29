import 'dart:async';
import 'package:alpu_pbl/admin/home_admin.dart';
import 'package:alpu_pbl/pasien/home.dart';
import 'package:alpu_pbl/shared_prefs.dart';
import 'package:flutter/material.dart';
import '../pasien/home_awal.dart';

void main() {
  runApp(MaterialApp(
    home: SplashPage(),
  ));
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToPilihanMasukPage();
  }

  _navigateToPilihanMasukPage() async {
    await Future.delayed(Duration(seconds: 4));
    final pref = await PreferencesUtil.getInstance();
    final role = pref?.getString(PreferencesUtil.role);
    if (mounted) {
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeAdminPage()),
        );
      } else if (role == 'pasien') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => HomeAwal(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 8, 100, 146),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Alpuu.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 16),
            Text(
              'Akses Layanan Pasien Umum',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 1.0,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
