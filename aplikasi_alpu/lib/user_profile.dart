// ignore_for_file: unnecessary_cast

import 'dart:io';
import 'package:alpu_pbl/form_validator.dart';
import 'package:alpu_pbl/main.dart';
import 'package:alpu_pbl/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'editdata.dart';
// import 'tes.dart';

class User {
  final String nama;
  final String email;
  final String alamat;
  final String nomorHp;
  String imageUrl;
  final String kataSandi;
  final String role;

  User({
    required this.nama,
    required this.email,
    required this.alamat,
    required this.nomorHp,
    required this.imageUrl,
    this.kataSandi = '',
    required this.role,
  });
}

class ProfileUser extends StatefulWidget {
  const ProfileUser({Key? key}) : super(key: key);

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  User? user;
  final keyNama = TextEditingController();
  final keyEmail = TextEditingController();
  final keyAlamat = TextEditingController();
  final keyNomorHp = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    keyNama.dispose();
    keyEmail.dispose();
    keyAlamat.dispose();
    keyNomorHp.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final pref = await PreferencesUtil.getInstance();
    final userId = pref?.getString(PreferencesUtil.userId);
    final role = pref?.getString(PreferencesUtil.role);
    final response = await http.get(
      Uri.parse('$baseUrl/api/profile/read.php?id=$userId&user_type=$role'),
    );
    debugPrint(response.body);
    if (mounted) {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        user = User(
          nama: data['name'],
          email: data['email'],
          alamat: data['alamat'],
          nomorHp: data['hp'],
          imageUrl: data['foto'],
          role: data['user_type'],
        );
        keyNama.text = user!.nama;
        keyEmail.text = user!.email;
        keyAlamat.text = user!.alamat;
        keyNomorHp.text = user!.nomorHp;

        /// set state diperlukan untuk mereload foto
        setState(() {});
      } else {
        throw Exception('Failed to load data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 9, 115, 160),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            navigatorKey.currentState?.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10.0),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(75.0),
                      child: Container(
                        width: 180.0,
                        height: 180.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0XFF097DAE),
                            width: 3.0,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          backgroundImage: (() {
                            try {
                              // ignore: unnecessary_null_comparison
                              if (user?.imageUrl.isNotEmpty == true) {
                                String foto = user?.role == "admin"
                                    ? '$baseUrl/api/admin/images/${user?.imageUrl}'
                                    : '$baseUrl/api/pasien/images/${user?.imageUrl}';
                                return NetworkImage(foto);
                              } else {
                                return const AssetImage(
                                        'assets/images/profile.png')
                                    as ImageProvider<Object>;
                              }
                            } catch (e) {
                              debugPrint('Error loading image: $e');
                              return const AssetImage(
                                      'assets/images/profile.png')
                                  as ImageProvider<Object>;
                            }
                          })(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Card(
                  elevation: 8.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0XFF097DAE),
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      'INFORMASI PRIBADI',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfileUser(user: user!)),
                                        );

                                        if (result == true && mounted) {
                                          const snackBar = SnackBar(
                                            content: Text(
                                              'Data berhasil Diubah!',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Color.fromARGB(
                                                255, 74, 188, 131),
                                          );

                                          // Panggil showSnackBar setelah data gagal diubah
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          fetchData();
                                        }
                                      },
                                      child: const Icon(
                                        Icons.edit_outlined,
                                        size: 24.0,
                                        color: Color.fromARGB(255, 10, 134, 59),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 10.0),
                                  height: 1.0,
                                  color: Colors.black,
                                  width: 250.0,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            key: const Key('nama'),
                            controller: keyNama,
                            readOnly: true,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black45)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black45)),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              labelText: 'Nama :',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            key: const Key('email'),
                            controller: keyEmail,
                            readOnly: true,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black45)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black45)),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              labelText: 'Email :',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            key: const Key('alamat'),
                            controller: keyAlamat,
                            readOnly: true,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black45)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black45)),
                              prefixIcon: Icon(
                                Icons.place_outlined,
                                color: Colors.black,
                              ),
                              labelText: 'Alamat :',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            key: const Key('nomor_telepon'),
                            controller: keyNomorHp,
                            readOnly: true,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black45)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.black45)),
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: Colors.black,
                              ),
                              labelText: 'Nomor Telepon :',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 250, 252, 252),
    );
  }
}

class EditProfileUser extends StatefulWidget {
  final User user;

  // ignore: non_constant_identifier_names
  const EditProfileUser({Key? key, required this.user}) : super(key: key);
  @override
  State<EditProfileUser> createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  final formKey = GlobalKey<FormState>();

  // final _foto = TextEditingController();
  final _namaLengkap = TextEditingController();
  final _kataSandi = TextEditingController();
  final _email = TextEditingController();
  final _nomorHp = TextEditingController();
  final _alamat = TextEditingController();
  String errorMessageUploadImage = '';
//=============================================================
  File? pictureFile;
//=============================================================
  Future _imageCamera() async {
    try {
      var imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (imageFile == null) return;

      pictureFile = File(imageFile.path);
      _uploadFoto();
    } on PlatformException catch (e) {
      debugPrint('Gagal Memilih Gambar: $e');
    }
  }

  Future _imageGallery() async {
    try {
      var imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile == null) return;

      pictureFile = File(imageFile.path);
      _uploadFoto();
    } on PlatformException catch (e) {
      debugPrint('Gagal Memilih Gambar: $e');
    }
  }

  void _uploadFoto() async {
    if (pictureFile == null) return;

    final bytes = await pictureFile!.readAsBytes();
    final fileName = pictureFile!.uri.pathSegments.last;
    // Simpan foto di server
    final url = widget.user.role == 'pasien'
        ? '$baseUrl/api/pasien/upload.php'
        : '$baseUrl/api/admin/upload.php';
    final request = http.MultipartRequest('POST', Uri.parse(url));
    final multipartFile =
        http.MultipartFile.fromBytes('image', bytes, filename: fileName);
    request.files.add(multipartFile);
    final response = await request.send();
    final body = await response.stream.first;
    final responseString = utf8.decode(body);
    debugPrint(responseString);
    if (mounted) {
      setState(() {
        errorMessageUploadImage = responseString;
        widget.user.imageUrl =
            fileName; // Mendapatkan URL foto dari response server
      });
    }
  }

//================================================================================================

  Future<bool> _updateProfile() async {
    try {
      debugPrint('Start _updatePasien');
      final pref = await PreferencesUtil.getInstance();
      final userId = pref?.getString(PreferencesUtil.userId) ?? '';
      var uri = Uri.parse("$baseUrl/api/profile/edit.php");

      final map = {
        'id': userId,
        'name': _namaLengkap.text,
        'sandi': _kataSandi.text,
        'email': _email.text,
        'hp': _nomorHp.text,
        'alamat': _alamat.text,
        'role': widget.user.role,
        'foto': widget.user.imageUrl,
      };

      var response = await http.post(uri, body: map);
      debugPrint("${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        debugPrint('Update Success');
        final pref = await PreferencesUtil.getInstance();
        pref?.putString(PreferencesUtil.email, _email.text);
        pref?.putString(PreferencesUtil.name, _namaLengkap.text);
        pref?.putString(PreferencesUtil.phone, _nomorHp.text);
        return true;
      } else {
        debugPrint('Update Failed: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      debugPrint('Error during update: $error');
      return false;
    }
  }

  /// coba restart mysqlnya
//================================================================================================

//===============================================================================
  @override
  void initState() {
    super.initState();

    _namaLengkap.text = widget.user.nama;
    _kataSandi.text =
        widget.user.kataSandi; // You may want to handle password separately
    _email.text = widget.user.email;
    _alamat.text = widget.user.alamat;
    _nomorHp.text = widget.user.nomorHp;
  }

  @override
  void dispose() {
    _namaLengkap.dispose();
    _kataSandi.dispose(); // You may want to handle password separately
    _email.dispose();
    _alamat.dispose();
    _nomorHp.dispose();
    super.dispose();
  }

//===================================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF097DAE),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10.0),
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(75.0),
                    child: Container(
                      width: 180.0,
                      height: 180.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0XFF097DAE),
                          width: 3.0,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        backgroundImage: (() {
                          var imageUrl = widget.user.imageUrl;
                          // ignore: unnecessary_null_comparison
                          if (imageUrl != null &&
                              imageUrl.isNotEmpty &&
                              imageUrl != ' ') {
                            String foto = widget.user.role == "admin"
                                ? '$baseUrl/api/admin/images/${widget.user.imageUrl}'
                                : '$baseUrl/api/pasien/images/${widget.user.imageUrl}';
                            return NetworkImage(foto);
                          } else {
                            return const AssetImage('assets/profile.png')
                                as ImageProvider<Object>;
                          }
                        })(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      width: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF097DAE),
                      ),
                      child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading:
                                        const Icon(Icons.photo_camera_outlined),
                                    title:
                                        const Text('Ambil Gambar dari Kamera'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _imageCamera();
                                    },
                                  ),
                                  ListTile(
                                    leading:
                                        const Icon(Icons.photo_library_rounded),
                                    title:
                                        const Text('Pilih Gambar dari Galeri'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _imageGallery();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.photo_camera_rounded,
                          color: Colors.white,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                errorMessageUploadImage,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 10.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0XFF097DAE),
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      right: 40.0,
                      bottom: 15.0,
                      left: 40.0,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _namaLengkap,
                            decoration: InputDecoration(
                              labelText: 'Nama Lengkap',
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.black),
                            ),
                            validator: FormValidator.validateName,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _kataSandi,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Kata Sandi',
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              prefixIcon:
                                  const Icon(Icons.lock, color: Colors.black),
                            ),
                            validator: (String? v) {
                              if (v?.isEmpty == true) return null;
                              return FormValidator.validatePassword(v);
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _email,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              prefixIcon:
                                  const Icon(Icons.email, color: Colors.black),
                            ),
                            validator: FormValidator.validateEmail,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _nomorHp,
                            decoration: InputDecoration(
                              labelText: 'Nomor Telepon',
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              prefixIcon: const Icon(Icons.phone_android,
                                  color: Colors.black),
                            ),
                            validator: FormValidator.validatePhoneNumber,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            controller: _alamat,
                            decoration: InputDecoration(
                              labelText: 'Alamat',
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              prefixIcon:
                                  const Icon(Icons.place, color: Colors.black),
                            ),
                            validator: FormValidator.validateAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() != true) {
                        return;
                      }
                      // Tambahkan logika untuk "Simpan" di sini
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Konfirmasi"),
                            content: const Text(
                                "Apakah anda yakin ingin menyimpan perubahan data profile anda?"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);

                                  /// proses update
                                  final result = await _updateProfile();
                                  if (mounted) {
                                    if (result == true) {
                                      navigatorKey.currentState?.pop(true);
                                    } else {
                                      const snackBar = SnackBar(
                                        content: Text(
                                          'Data Gagal Diubah!',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.red,
                                      );

                                      // Panggil showSnackBar setelah data gagal diubah
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 7, 84,
                                      166), // Ganti warna latar belakang menjadi biru tua
                                  primary: Colors
                                      .white, // Ganti warna teks menjadi putih
                                ),
                                child: const Text("Iya"),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Jika pengguna menekan tombol "Tidak", maka dialog box akan ditutup
                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors
                                      .red, // Ganti warna latar belakang menjadi merah
                                  primary: Colors
                                      .white, // Ganti warna teks menjadi putih
                                ),
                                child: const Text("Tidak"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0XFF097DAE)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(150, 50)),
                    ),
                    child: const Text(
                      'SIMPAN',
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0XFFFA281B)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(150, 50)),
                    ),
                    child: const Text(
                      'BATAL',
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
