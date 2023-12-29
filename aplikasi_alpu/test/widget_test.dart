import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alpu_pbl/splash.dart'; // Import file login.dart atau sesuaikan dengan struktur aplikasi Anda

void main() {
  testWidgets('Login page UI test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: SplashPage(), // Gunakan LoginPage sebagai halaman utama
    ));

    // Verifikasi bahwa elemen-elemen UI yang diharapkan ada
    expect(find.text('NIK'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Masuk'), findsOneWidget);

    // Selanjutnya, Anda dapat menambahkan langkah-langkah tes lainnya sesuai kebutuhan Anda.
  });
}
