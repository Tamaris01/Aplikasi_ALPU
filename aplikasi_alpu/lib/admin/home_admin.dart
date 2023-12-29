import 'package:alpu_pbl/user_profile.dart';
import 'package:alpu_pbl/main.dart';
import 'package:alpu_pbl/shared_prefs.dart';
import 'package:flutter/material.dart';
import '../admin/kelola_dokter.dart';
import '../admin/kelola_pasien.dart';
import '../admin/kelola_jadwal.dart';
import '../admin/konfirmasi.dart';
import '../admin/kelola_poliklinik.dart';
import '../splash.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class HomeAdminPage extends StatefulWidget {
  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  String name = '';
  final List<String> hospitalImages = [
    "assets/images/home.png",
    "assets/images/poli.jpeg",
    "assets/images/rs_embung.jpg",
  ];
  late PageController _pageController;
  int _currentPage = 0;

  final List<FeatureItem> featureItems = [
    FeatureItem("Konfirmasi\nKehadiran", "assets/images/confirm.png",
        (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KehadiranPage(),
        ),
      );
    }),
    FeatureItem("Kelola Poliklinik", "assets/images/info.png",
        (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const KelolaPoliklinikPage(),
        ),
      );
    }),
    FeatureItem("Kelola Jadwal\nDokter", "assets/images/jadwal.png",
        (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KelolaJadwalDokterPage(),
        ),
      );
    }),
    FeatureItem("Kelola Dokter", "assets/images/doctor.png",
        (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KelolaDokterPage(),
        ),
      );
    }),
    FeatureItem("Kelola Pasien", "assets/images/kelola_pasien.png",
        (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KelolaPasienPage(),
        ),
      );
    }),
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
        _loadAdmin();
      });
      featureItems.add(item);
    }

    filteredFeatureItems = featureItems;
    _loadAdmin();

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
          title: Text(
            "ALPU",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 8, 90, 132),
          elevation: 4,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white, // Warna putih
              ),
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
                      "Selamat datang, $name!",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 8, 90, 132),
                      ),
                    ),
                  ],
                ),
              ),
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
                    "Menu Admin",
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
                      filteredFeatureItems = featureItems
                          .where((item) => item.title
                              .toLowerCase()
                              .contains(text.toLowerCase()))
                          .toList();
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
  //$2y$10$blJK3qF2kZkR4SUnqyoXu.WT8oC1.unaFlE3Tc94pIizFYgNkRpQm
  //$2y$10$k96Wc.b5.ePFDkUtNFuzreITjMKMeM5at2sMo.ltwJJx80GpBnu4y
  //$2y$10$Kojrix4cR4PrqcdvMbEiDeDrCvsQeYQfq\/XxOKSU5qb0chUGI1gW6

  Widget _buildBottomNavigationBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services), // Ubah ikon di sini
            label: 'Kelola Pasien',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Kelola Jadwal',
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 8, 90, 132),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 251, 252, 255),
        onTap: (int index) {
          switch (index) {
            case 0:
              // Tambahkan logika untuk beranda di sini
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KelolaPasienPage(),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KelolaJadwalDokterPage(),
                ),
              );
              break;
          }
        },
      ),
    );
  }

  void _handleLogout() async {
    try {
      final pref = await PreferencesUtil.getInstance();
      await pref?.clearAll();

      final response = await http.post(
        Uri.parse('$baseUrl/api/logout.php'),
      );
      debugPrint(response.body);
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

  void _loadAdmin() async {
    final pref = await PreferencesUtil.getInstance();
    name = pref?.getString(PreferencesUtil.name) ?? '';
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
