import 'package:alpu_pbl/main.dart';
import 'package:alpu_pbl/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../pasien/home.dart';
// import 'reset_katasandi.dart';
import '../admin/home_admin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController credentialController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isObscure = true;

  Future<void> login() async {
    if (credentialController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi semua bidang'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final credential = credentialController.text;
    final kata_sandi = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login.php'),
        body: {'credential': credential, 'kata_sandi': kata_sandi},
      );

      setState(() {
        isLoading = false;
      });
      debugPrint(response.body);
      if (response.statusCode == 200) {
        (await SharedPreferences.getInstance())
            .setString(PreferencesUtil.userId, credential);
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final pref = await PreferencesUtil.getInstance();
          await pref?.putString(PreferencesUtil.userId, data['id']);
          await pref?.putString(PreferencesUtil.name, data['name']);
          await pref?.putString(PreferencesUtil.email, data['email']);
          await pref?.putString(PreferencesUtil.role, data['user_type']);
          await pref?.putString(
              PreferencesUtil.rekamMedis, data['nomor_rekam_medis'] ?? '');
          if (mounted) {
            if (data['user_type'] == 'admin') {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeAdminPage()),
                  (r) => false);
            } else if (data['user_type'] == 'pasien') {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (r) => false);
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(data['message'] ?? 'Gagal login'),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Terjadi kesalahan. Periksa koneksi Anda.'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan. Periksa koneksi Anda.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget build
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: const Color.fromARGB(255, 8, 100, 146),
              child: Center(
                child: Image.asset(
                  "assets/images/login.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: _buildForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    // Form Login
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              "assets/images/Alpuu.png",
              height: mediaSize.height * 0.1,
              width: mediaSize.width * 0.3,
            ),
            const SizedBox(height: 20),
            _buildInputField("Nomor ID", credentialController),
            const SizedBox(height: 20),
            _buildInputField("Kata Sandi", passwordController,
                isPassword: true),
            const SizedBox(height: 20),
            _buildLoginButton(),
            const SizedBox(
                height: 10), // Spasi antara tombol login dan reset kata sandi
            // TextButton(
            //   onPressed: () {
            //     // Navigasi ke halaman reset kata sandi saat tombol ditekan
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ResetPasswordPage(),
            //       ),
            //     );
            //   },
            //   child: const Text(
            //     'Lupa Kata Sandi?',
            //     style: TextStyle(
            //       color: Color.fromARGB(255, 8, 100, 146),
            //     ),
            //   ),
            // ),
          ], // Tambahkan widget TextButton ke dalam children
        ),
      ),
    );
  }

  Widget _buildInputField(String labelText, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(255, 8, 100, 146),
        ),
        boxShadow: [
          const BoxShadow(
            color: Color.fromARGB(255, 8, 100, 146),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: labelText,
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 8, 100, 146),
          ),
        ),
        obscureText: isPassword ? isObscure : false,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : login,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        primary: const Color.fromARGB(255, 8, 100, 146),
        onPrimary: const Color.fromARGB(255, 246, 246, 246),
        minimumSize: const Size(10, 45),
        padding: const EdgeInsets.symmetric(horizontal: 40),
      ),
      child: isLoading
          ? const CircularProgressIndicator()
          : const Text(
              "Masuk",
              style: TextStyle(fontSize: 16),
            ),
    );
  }
}
