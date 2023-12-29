import 'dart:convert';
import 'package:alpu_pbl/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PencarianDokter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PencarianDokterPage(),
    );
  }
}

class Dokter {
  final String nipDokter;
  final String idAdmin;
  final String nama;
  final String idPoliklinik;
  String namaPoliklinik;
  final String alamat;
  final String noTelepon;
  final String foto;

  Dokter({
    required this.nipDokter,
    required this.nama,
    required this.idPoliklinik,
    required this.namaPoliklinik,
    required this.alamat,
    required this.noTelepon,
    required this.foto,
    required this.idAdmin,
  });

  factory Dokter.fromJson(Map<String, dynamic> json) {
    return Dokter(
      nama: json['nama_dokter'],
      idAdmin: json['id_admin'] ?? '',
      idPoliklinik: json['id_poliklinik'] ?? '',
      namaPoliklinik: json['nama_poliklinik'] ?? '',
      alamat: json['alamat'] ?? '',
      noTelepon: json['no_telepon'] ?? '',
      foto: json['foto'] ?? '',
      nipDokter: json['nip_dokter'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_dokter': nama,
      'id_admin': idAdmin,
      'id_poliklinik': idPoliklinik,
      'nama_poliklinik': namaPoliklinik,
      'alamat': alamat,
      'no_telepon': noTelepon,
      'foto': foto,
      'nip_dokter': nipDokter,
    };
  }
}

// Poliklinik
class Poliklinik {
  final String idPoliklinik; // Menggunakan String untuk ID poliklinik
  final String namaPoliklinik;

  Poliklinik({required this.idPoliklinik, required this.namaPoliklinik});

  factory Poliklinik.fromJson(Map<String, dynamic> json) {
    return Poliklinik(
      idPoliklinik: json['id_poliklinik'],
      namaPoliklinik: json['nama_poliklinik'],
    );
  }
}

class PencarianDokterPage extends StatefulWidget {
  @override
  _PencarianDokterPageState createState() => _PencarianDokterPageState();
}

class _PencarianDokterPageState extends State<PencarianDokterPage> {
  List<Dokter> dokterList = [];
  List<Dokter> filteredDokterList = [];
  TextEditingController searchController = TextEditingController();
// List poliklinik
  List<Poliklinik> poliklinikList = [];
  Poliklinik? selectedPoliklinik;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  //poliklinik
  Future<void> fetchDataPoliklinik() async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/api/poliklinik/read.php"));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          poliklinikList = data
              .map((poliklinik) => Poliklinik.fromJson(poliklinik))
              .toList();
        });

        print(poliklinikList
            .map((poliklinik) => poliklinik.namaPoliklinik)
            .toList());
      } else {
        print('Error fetching data - status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/api/dokter/read.php"));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          dokterList = data.map((item) => Dokter.fromJson(item)).toList();
          filteredDokterList = dokterList;
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void filterDokter(String query) {
    setState(() {
      filteredDokterList = dokterList
          .where((dokter) =>
              dokter.nama.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<bool> updateDokter(Dokter dokter) async {
    final map = dokter.toJson();
    map['nip_dokter'] = dokter.nipDokter;
    map['no_telepon'] = dokter.noTelepon;
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/dokter/edit.php"),
        body: map,
      );

      if (response.statusCode == 200) {
        print('Dokter ${dokter.nama} berhasil diupdate.');
        return true;
      } else {
        print('Gagal mengupdate dokter. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pencarian Dokter",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 8, 90, 132),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(screenWidth > 600 ? 16.0 : 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            TextField(
              controller: searchController,
              onChanged: filterDokter,
              decoration: InputDecoration(
                hintText: 'Cari Dokter...',
                suffixIcon: Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 8, 90, 132),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 8, 90, 132),
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 8, 90, 132),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 8, 90, 132),
                    width: 2.0,
                  ),
                ),
                labelText: 'Cari Dokter...',
                labelStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16.0,
                ),
              ),
              style: TextStyle(
                color: Color.fromARGB(255, 8, 90, 132),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDokterList.length,
                itemBuilder: (context, index) {
                  Dokter dokter = filteredDokterList[index];
                  return Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 8, 90, 132),
                        width: 2.0,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: index % 2 == 0
                        ? const Color.fromARGB(255, 184, 223, 250)
                        : const Color.fromARGB(255, 205, 247, 253),
                    child: InkWell(
                      onTap: () {
                        // Add action on card tap if needed
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                  color: const Color.fromARGB(255, 8, 90, 132),
                                  width: 3.0,
                                ),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: dokter.foto.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        child: Image.network(
                                          '$baseUrl/api/dokter/images/${dokter.foto}',
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Placeholder(), // Placeholder saat tidak ada gambar
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        dokter.nama,
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 8, 90, 132),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'NIP Dokter: ${dokter.nipDokter}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color:
                                              Color.fromARGB(255, 8, 90, 132),
                                        ),
                                      ),
                                      Text(
                                        'Poliklinik: ${dokter.namaPoliklinik}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color:
                                              Color.fromARGB(255, 8, 90, 132),
                                        ),
                                      ),
                                      Text(
                                        'No. Telepon: ${dokter.noTelepon}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color:
                                              Color.fromARGB(255, 8, 90, 132),
                                        ),
                                      ),
                                      Text(
                                        'Alamat: ${dokter.alamat}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color:
                                              Color.fromARGB(255, 8, 90, 132),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
