import 'dart:convert';
import 'package:alpu_pbl/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../admin/kelola_dokter.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class FormulirPage extends StatefulWidget {
  @override
  _FormulirPageState createState() => _FormulirPageState();
}

class _FormulirPageState extends State<FormulirPage> {
  List<Poliklinik> poliklinikList = [];
  List<Dokter> dokterList = [];
  TextEditingController namaController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController nomorRekamMedisController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  Poliklinik? dataPoliklinik;
  Dokter? dataDokter;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;
    if (picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    super.initState();
    _loadAuth();
    _fetchPoliklinik();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pendaftaran Online",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 8, 90, 132),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(screenWidth > 600 ? 24.0 : 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 6.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 8, 90, 132),
                    width: 2.0,
                  ),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(screenWidth > 600 ? 28.0 : 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'FORMULIR PENDAFTARAN',
                        style: TextStyle(
                          fontSize: screenWidth > 600 ? 28.0 : 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenWidth > 600 ? 24.0 : 14.0),
                      buildLabeledTextField(
                        "Nama Lengkap",
                        namaController,
                        screenWidth,
                        enable: false,
                      ),
                      SizedBox(height: screenWidth > 600 ? 24.0 : 14.0),
                      buildLabeledTextField(
                        "NIK",
                        nikController,
                        screenWidth,
                        enable: false,
                      ),
                      SizedBox(height: screenWidth > 600 ? 24.0 : 14.0),
                      buildLabeledTextField(
                        "Nomor Rekam Medis",
                        nomorRekamMedisController,
                        screenWidth,
                        enable: false,
                      ),
                      SizedBox(height: screenWidth > 600 ? 24.0 : 12.0),
                      DropdownButtonFormField<Poliklinik>(
                        decoration: const InputDecoration(
                          hintText: 'Pilih Poliklinik',
                          labelText: 'Pilih Poliklinik',
                          prefixIcon: Icon(Icons.local_hospital_sharp,
                              color: Color.fromARGB(255, 8, 90, 132)),
                          // Warna ikon
                          labelStyle:
                              TextStyle(color: Color.fromARGB(255, 8, 90, 132)),
                          // Warna teks label
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(
                                  255, 8, 90, 132), // Warna border
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 8, 90,
                                  132), // Warna border saat dalam keadaan normal
                            ),
                          ),
                        ),
                        value: dataPoliklinik,
                        onChanged: (Poliklinik? value) {
                          setState(() {
                            dataDokter = null;
                            dataPoliklinik = value;
                            dokterList = [];
                            fetchDokterByPoliklinik(
                                dataPoliklinik?.idPoliklinik ?? '');
                          });
                        },
                        items: poliklinikList.map((master) {
                          return DropdownMenuItem(
                            value: master,
                            child: Row(
                              children: [
                                const SizedBox(width: 5),
                                Text(
                                  master.namaPoliklinik,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 8, 90, 132)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: screenWidth > 600 ? 24.0 : 14.0),
                      DropdownButtonFormField<Dokter>(
                        decoration: const InputDecoration(
                          labelText: 'Pilih Dokter',
                          labelStyle:
                              TextStyle(color: Color.fromARGB(255, 8, 90, 132)),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 8, 90, 132),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 8, 90, 132),
                            ),
                          ),
                          prefixIcon: Icon(Icons.person,
                              color: Color.fromARGB(255, 8, 90, 132)),
                        ),
                        value: dataDokter,
                        onChanged: (Dokter? value) {
                          setState(() {
                            dataDokter = value;
                            print("Hasil : ${dataPoliklinik?.idPoliklinik}");
                          });
                        },
                        items: dokterList.map((Dokter dokter) {
                          return DropdownMenuItem<Dokter>(
                            value: dokter,
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Text(dokter.nama),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: screenWidth > 600 ? 24.0 : 14.0),
                      buildLabeledDateInput("Tanggal", screenWidth),
                      SizedBox(height: screenWidth > 600 ? 14.0 : 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (dataPoliklinik == null ||
                                  dataDokter == null ||
                                  selectedDate == null) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Kesalahan'),
                                      content:
                                          const Text('Harap isi semua kolom!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Tutup'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                _simpanPendaftaran();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 8, 90, 132),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 25.0,
                              ),
                            ),
                            child: const Text(
                              'Daftar',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabeledTextField(
      String label, TextEditingController controller, double screenWidth,
      {bool enable = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth > 600 ? 16.0 : 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          enabled: enable,
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          ),
        ),
      ],
    );
  }

  Widget buildLabeledDropdown(
      String label, String value, List<String> items, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth > 600 ? 18.0 : 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: (newValue) {
            setState(() {
              value = newValue!;
            });
          },
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget buildLabeledDateInput(String label, double screenWidth) {
    final DateFormat dateFormat = DateFormat("dd-MM-yyyy");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth > 600 ? 20.0 : 12.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        InkWell(
          onTap: () {
            _selectDate(context);
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  selectedDate != null
                      ? dateFormat.format(selectedDate!)
                      : 'Pilih Tanggal',
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 16.0 : 12.0,
                  ),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _loadAuth() async {
    final pref = await PreferencesUtil.getInstance();
    namaController.text = pref?.getString(PreferencesUtil.name) ?? '';
    nikController.text = pref?.getString(PreferencesUtil.userId) ?? '';
    nomorRekamMedisController.text =
        pref?.getString(PreferencesUtil.rekamMedis) ?? '';
  }

  Future<void> _fetchPoliklinik() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/poliklinik/get_poliklinik.php"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        poliklinikList = data
            .map((item) => Poliklinik(
                  idPoliklinik: item['id_poliklinik'],
                  namaPoliklinik: item['nama_poliklinik'],
                ))
            .toList();

        // Hilangkan duplikat
        poliklinikList = poliklinikList.toSet().toList();
      });
    } else {
      throw Exception('Failed to load poliklinik data');
    }
  }

  Future<void> fetchDokterByPoliklinik(String idPoliklinik) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/poliklinik/get_dokter_by_poliklinik.php"),
      body: json.encode({"id_poliklinik": idPoliklinik}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dokterList = data.map((item) => Dokter.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load dokter data');
    }
  }

  void _simpanPendaftaran() async {
    final map = {
      'nik': nikController.text,
      'id_poliklinik': dataPoliklinik?.idPoliklinik,
      'nip_dokter': dataDokter?.nipDokter,
      'tanggal': DateFormat('yyyy-MM-dd').format(selectedDate!),
    };

    bool? confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Anda yakin ingin mendaftarkan data ini?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 19, 98, 163),
                onPrimary: Colors.white,
              ),
              child: Text('Ya'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 216, 47, 35),
                onPrimary: Colors.white,
              ),
              child: Text('Tidak'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final response = await http.post(
        Uri.parse('$baseUrl/api/pendaftaran/create.php?data=pendaftaran'),
        body: map,
      );
      final mapResponse = json.decode(response.body);

      if (mounted) {
        if (mapResponse['status'] == 'error') {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Gagal'),
                content: Text(mapResponse['message'] ?? 'Terjadi kesalahan'),
              );
            },
          );
        } else {
          // Tampilkan notifikasi Snackbar saat data berhasil disimpan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil disimpan'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color.fromARGB(
                  255, 76, 175, 167), // Warna hijau di sini
            ),
          );

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Berhasil'),
                content: Text(mapResponse['message'] ?? 'Pendaftaran berhasil'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }
}
