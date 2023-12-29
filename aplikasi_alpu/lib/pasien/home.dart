import 'package:alpu_pbl/user_profile.dart';
import 'package:alpu_pbl/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pasien/info.dart';
import '../pasien/jadwal.dart';
import '../pasien/formulir.dart';
import '../pasien/riwayat.dart';
import '../pasien/pencarian_dokter.dart';
import 'dart:async';
import '../lokasi.dart';
import 'package:alpu_pbl/main.dart';
import '../splash.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = '';
  String noRekamMedis = '';

  int _selectedIndex = 0;
  final List<String> hospitalImages = [
    "assets/images/home.png",
    "assets/images/poli.jpeg",
    "assets/images/rs_embung.jpg",
  ];
  late PageController _pageController;
  int _currentPage = 0;

  final List<FeatureItem> featureItems = [
    FeatureItem("Pendaftaran Online", "assets/images/formulir.png", (context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormulirPage(),
        ),
      );
    }),
    FeatureItem("Info Layanan", "assets/images/info.png", (context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InfoPage(),
        ),
      );
    }),
    FeatureItem("Jadwal Dokter", "assets/images/jadwal.png", (context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JadwalPage(),
        ),
      );
    }),
    FeatureItem("Pencarian Dokter", "assets/images/doctor.png", (context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PencarianDokterPage(),
        ),
      );
    }),
    FeatureItem("Riwayat Pendaftaran", "assets/images/history.png", (context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RiwayatPage(),
        ),
      );
    }),
    // FeatureItem("Profile", "assets/images/profile.png", (context) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const ProfileUser(),
    //     ),
    //   );
    // }),
  ];
  List<FeatureItem> filteredFeatureItems = [];
  @override
  void initState() {
    super.initState();
    final cek =
        featureItems.where((element) => element.title == 'Profil').toList();
    if (cek.isEmpty) {
      final item = FeatureItem("Profil", "assets/images/profile.png",
          (BuildContext context) async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileUser(),
          ),
        );
        _loadAuth();
      });
      featureItems.add(item);
    }

    filteredFeatureItems = featureItems;
    _loadAuth();

    _pageController = PageController(initialPage: _currentPage);

    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < hospitalImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ALPU"),
          backgroundColor: const Color.fromARGB(255, 8, 90, 132),
          elevation: 4,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: IntrinsicHeight(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    "Apakah Anda yakin ingin keluar?",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          const Color.fromARGB(255, 8, 90, 132),
                                    ),
                                    onPressed: () async {
                                      _handleLogout(); // Panggil void logout saat tombol "Iya" diklik
                                    },
                                    child: const Text("Iya"),
                                  ),
                                  const SizedBox(width: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Tidak"),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Datang, $name",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 8, 90, 132),
                      ),
                    ),
                    Text(
                      "No.Rekam Medis: $noRekamMedis",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: PageView.builder(
                    controller:
                        _pageController, // Tambahkan _pageController di sini
                    itemCount: hospitalImages.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          hospitalImages[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Layanan Pasien Umum",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 8, 90, 132),
                      letterSpacing: 1.0,
                      shadows: [
                        Shadow(
                          blurRadius: 2,
                          color: Color(0xFFCCEBFF),
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Cari layanan",
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 8, 90, 132),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 8, 90, 132),
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 8, 90, 132),
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 8, 90, 132),
                        width: 2.0,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 8, 90, 132),
                    fontStyle: FontStyle.italic,
                  ),
                  onChanged: (text) {
                    setState(() {
                      if (text.isEmpty) {
                        filteredFeatureItems = featureItems;
                      } else {
                        filteredFeatureItems = featureItems
                            .where((item) => item.title
                                .toLowerCase()
                                .contains(text.toLowerCase()))
                            .toList();
                      }
                    });
                  },
                ),
              ),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width > 400 ? 3 : 2,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredFeatureItems.length,
                itemBuilder: (context, index) {
                  return _buildFeatureCard(
                      filteredFeatureItems[index], context);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  Widget _buildFeatureCard(FeatureItem featureItem, BuildContext context) {
    return GestureDetector(
      onTap: () => featureItem.onTap(context),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
              color: Color.fromARGB(255, 8, 90, 132), width: 3.0),
        ),
        margin: const EdgeInsets.all(15.10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              featureItem.icon,
              width: 45,
              height: 45,
            ),
            const SizedBox(height: 8),
            Text(
              featureItem.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 8, 100, 146),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/images/whatsapp.png'),
            size: 20,
          ),
          label: 'WhatsApp admin',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Lokasi',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.notification_add_rounded),
        //   label: 'Notifikasi',
        // ),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromARGB(255, 8, 100, 146),
      elevation: 1,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
          if (index == 1) {
            openWhatsApp();
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LokasiPage(),
              ),
            );
            // } else if (index == 3) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => const NotifikasiPage(),
            //     ),
            //   );
          }
        });
      },
    );
  }

  openWhatsApp() async {
    String phoneNumber =
        "6282171336032"; // Ganti dengan nomor telepon Anda tanpa awalan "+"
    String message = "Hello";

    String whatsappUrl =
        "https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("WhatsApp is not installed")),
      );
    }
  }

  void _handleLogout() async {
    try {
      final pref = await PreferencesUtil.getInstance();
      await pref?.clearAll();

      final response = await http.post(
        Uri.parse('$baseUrl/api/logout.php'),
      );

      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SplashPage(),
          ),
          (r) => false,
        );

        _showSnackBar('Logout berhasil',
            backgroundColor: Color.fromARGB(255, 64, 190, 131));
      } else {
        throw Exception('Logout gagal');
      }
    } catch (e) {
      print('Error during logout: $e');
      _showSnackBar('Terjadi kesalahan saat logout',
          backgroundColor: Colors.red);
    }
  }

  void _showSnackBar(String message, {Color backgroundColor = Colors.green}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _loadAuth() async {
    final pref = await PreferencesUtil.getInstance();
    name = pref?.getString(PreferencesUtil.name) ?? '';
    noRekamMedis = pref?.getString(PreferencesUtil.rekamMedis) ?? '';
    if (mounted) {
      setState(() {});
    }
  }
}

class FeatureItem {
  final String title;
  final String icon;
  final Function(BuildContext) onTap;

  FeatureItem(this.title, this.icon, this.onTap);
}
