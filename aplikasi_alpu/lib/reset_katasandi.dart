import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController credentialController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final String baseUrl = 'http://192.168.101.64'; // Ganti dengan base URL Anda

  Future<void> resetPassword(String credential, String newPassword) async {
    final Uri uri = Uri.parse('$baseUrl/api/reset_katasandi.php');
    try {
      final response = await http.post(
        uri,
        body: {'credential': credential, 'new_password': newPassword},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Reset kata sandi berhasil
          // Tambahkan logika atau navigasi ke halaman login
          print('Reset kata sandi berhasil');
        } else {
          // Gagal reset kata sandi
          print('Gagal reset kata sandi');
        }
      } else {
        // Terjadi kesalahan saat melakukan panggilan API
        print('Terjadi kesalahan saat melakukan panggilan API');
      }
    } catch (e) {
      // Tangani kesalahan jaringan atau lainnya
      print('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Kata Sandi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: credentialController,
              decoration: InputDecoration(
                labelText: 'Credential',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String credential = credentialController.text;
                String newPassword = newPasswordController.text;
                resetPassword(credential, newPassword);
              },
              child: Text('Reset Kata Sandi'),
            ),
          ],
        ),
      ),
    );
  }
}
