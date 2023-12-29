import 'dart:convert';

import 'package:alpu_pbl/admin/kelola_dokter.dart';
import 'package:alpu_pbl/admin/kelola_jadwal.dart' as kj;
import 'package:alpu_pbl/main.dart';
import 'package:alpu_pbl/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

class AddJadwalPage extends StatefulWidget {
  const AddJadwalPage({super.key, this.jadwal});
  final kj.JadwalDokter? jadwal;

  @override
  State<AddJadwalPage> createState() => _AddJadwalPageState();
}

class _AddJadwalPageState extends State<AddJadwalPage> {
  static const days = [
    "Unknown",
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jum'at",
    "Sabtu",
    "Minggu",
  ];
  List<Poliklinik> poliklinikList = [];
  List<Dokter> dokterList = [];
  TextEditingController idController = TextEditingController();
  TextEditingController nipDokterController = TextEditingController();
  TextEditingController idPoliklinikController = TextEditingController();
  TextEditingController jamMulaiController = TextEditingController();
  TextEditingController jamSelesaiController = TextEditingController();
  TextEditingController hariController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  TimeOfDay selectedJamMulai = TimeOfDay.now();
  TimeOfDay selectedJamSelesai = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  Poliklinik? dataPoliklinik;
  Dokter? dataDokter;

  void _showStyledSnackBar(
      String message, IconData icon, Color iconColor, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          height: 60.0,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 30.0,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    _showStyledSnackBar(
        message, Icons.check_circle_outline, Colors.white, Colors.green);
  }

  void _showErrorSnackBar(String message) {
    _showStyledSnackBar(message, Icons.error_outline, Colors.white, Colors.red);
  }

  @override
  void initState() {
    super.initState();
    fetchPoliklinik();
    if (widget.jadwal != null) {
      idController.text = widget.jadwal!.id;
      nipDokterController.text = widget.jadwal!.nipDokter;
      selectedJamMulai = widget.jadwal!.jamMulai;
      selectedJamSelesai = widget.jadwal!.jamSelesai;
      hariController.text = widget.jadwal!.hari;
      try {
        if (widget.jadwal?.tanggal.contains('-') == true) {
          selectedDate =
              DateFormat('yyyyy-MM-dd').parse(widget.jadwal?.tanggal ?? '');
          tanggalController.text =
              DateFormat('yyyy-MM-dd').format(selectedDate);
        }
      } catch (e) {}
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      jamMulaiController.text = selectedJamMulai.format(context);
      jamSelesaiController.text = selectedJamSelesai.format(context);
    });
  }

  Future<void> fetchPoliklinik() async {
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
        if (widget.jadwal != null) {
          final cek = poliklinikList
              .where((element) =>
                  element.idPoliklinik == widget.jadwal?.idPoliklinik)
              .toList();

          if (cek.isNotEmpty) {
            dataPoliklinik = cek.first;
            fetchDokterByPoliklinik(dataPoliklinik?.idPoliklinik ?? '');
          }
        }
      });
    } else {
      throw Exception('Failed to load poliklinik data');
    }
  }

  var firstTime = true;
  Future<void> fetchDokterByPoliklinik(String idPoliklinik) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/poliklinik/get_dokter_by_poliklinik.php"),
      body: json.encode({"id_poliklinik": idPoliklinik}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> dataList = json.decode(response.body);
      if (mounted) {
        setState(() {
          dokterList = dataList.map((item) => Dokter.fromJson(item)).toList();
          if (firstTime && widget.jadwal != null) {
            firstTime = false;
            final cek = dokterList
                .where(
                    (element) => element.nipDokter == widget.jadwal?.nipDokter)
                .toList();
            if (cek.isNotEmpty) {
              dataDokter = cek.first;
            }
          }
        });
      }
    } else {
      throw Exception('Failed to load dokter data');
    }
  }

  Future<void> _selectTime(BuildContext context, bool isJamMulai) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isJamMulai ? selectedJamMulai : selectedJamSelesai,
    );

    if (pickedTime != null &&
        pickedTime != (isJamMulai ? selectedJamMulai : selectedJamSelesai)) {
      setState(() {
        if (isJamMulai) {
          selectedJamMulai = pickedTime;
          jamMulaiController.text =
              pickedTime.format(context); // Set text controller value
        } else {
          selectedJamSelesai = pickedTime;
          jamSelesaiController.text =
              pickedTime.format(context); // Set text controller value
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    var firstDate = DateTime.now();
    if (selectedDate.isBefore(firstDate)) {
      firstDate = selectedDate;
    }
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: DateTime(2101),
        // locale: const Locale('in_ID'),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light(),
            child: child!,
          );
        });

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        tanggalController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        hariController.text = days[selectedDate.weekday];
      });
    }
  }

  Future<void> _addSimpanJadwalDokter() async {
    final pref = await PreferencesUtil.getInstance();
    final idAdmin = pref?.getString(PreferencesUtil.userId) ?? "";
    Map<String, dynamic> data = {
      'id': idController.text,
      'id_admin': idAdmin,
      'nip_dokter': dataDokter?.nipDokter ?? '',
      'id_poliklinik': dataPoliklinik?.idPoliklinik,
      'jam_mulai':
          "${selectedJamMulai.hour.toString().padLeft(2, '0')}:${selectedJamMulai.minute.toString().padLeft(2, '0')}:00",
      'jam_selesai':
          "${selectedJamSelesai.hour.toString().padLeft(2, '0')}:${selectedJamSelesai.minute.toString().padLeft(2, '0')}:00",
      'hari': days[selectedDate.weekday],
      'tanggal': DateFormat('yyyy-MM-dd').format(selectedDate),
    };
    final url = widget.jadwal == null
        ? "$baseUrl/api/jadwal_dokter/create.php"
        : "$baseUrl/api/jadwal_dokter/edit.php";
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: {"Content-Type": "application/json"},
    );
    debugPrint(response.body);
    if (response.statusCode == 200) {
      print('Data Jadwal Berhasil tersimpan');
      _showSuccessSnackBar('Data Jadwal Berhasil tersimpan');
      if (mounted) Navigator.pop(context);
    } else {
      print('Data Jadwal gagal tersimpan');
      _showErrorSnackBar('Data Jadwal gagal  tersimpan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.jadwal == null ? 'Tambah Jadwal Dokter' : 'Edit Jadwal Dokter',
        ),
        backgroundColor: const Color.fromARGB(255, 8, 90, 132),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 5),
            const Text(
              'Poliklinik',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 8, 90, 132),
              ),
            ),
            const SizedBox(height: 5.0),
            DropdownButtonFormField<Poliklinik>(
              decoration: const InputDecoration(
                labelText: 'Pilih Poliklinik',
                prefixIcon: Icon(Icons.local_hospital_sharp,
                    color: Color.fromARGB(255, 8, 90, 132)), // Warna ikon
                labelStyle: TextStyle(
                    color: Color.fromARGB(255, 8, 90, 132)), // Warna teks label
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 8, 90, 132), // Warna border
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
                  fetchDokterByPoliklinik(dataPoliklinik?.idPoliklinik ?? '');
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
                            color: Color.fromARGB(
                                255, 8, 90, 132)), // Warna teks item dropdown
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dokter',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 8, 90, 132),
              ),
            ),
            const SizedBox(height: 5.0),
            DropdownButtonFormField<Dokter?>(
              decoration: const InputDecoration(
                labelText: 'Pilih Dokter',
                labelStyle: TextStyle(color: Color.fromARGB(255, 8, 90, 132)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 8, 90, 132), // Warna border
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 8, 90,
                        132), // Warna border saat dalam keadaan normal
                  ),
                ),
                prefixIcon:
                    Icon(Icons.person, color: Color.fromARGB(255, 8, 90, 132)),
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
            const SizedBox(height: 16),
            const Text(
              'Jam Mulai',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 8, 90, 132),
              ),
            ),
            const SizedBox(height: 5.0),
            GestureDetector(
              onTap: () async {
                await _selectTime(context, true);
                setState(() {});
              },
              child: Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Color.fromARGB(255, 8, 90, 132), // Warna border
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 8, 90,
                                132), // Warna border saat dalam keadaan normal
                          ),
                        ),
                        suffixIcon: Icon(Icons.access_time,
                            color: Color.fromARGB(255, 8, 90, 132)),
                      ),
                      child: Text(
                        selectedJamMulai.format(context),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 8, 90, 132),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Jam Selesai',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 8, 90, 132),
              ),
            ),
            const SizedBox(height: 5.0),
            GestureDetector(
              onTap: () async {
                await _selectTime(context, false);
                setState(() {});
              },
              child: Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Color.fromARGB(255, 8, 90, 132), // Warna border
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 8, 90,
                                132), // Warna border saat dalam keadaan normal
                          ),
                        ),
                        suffixIcon: Icon(Icons.access_time,
                            color: Color.fromARGB(255, 8, 90, 132)),
                      ),
                      child: Text(
                        selectedJamSelesai.format(context),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 8, 90, 132),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tanggal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 8, 90, 132),
              ),
            ),
            const SizedBox(height: 5.0),
            GestureDetector(
              onTap: () async {
                await _selectDate(context);
                setState(() {});
              },
              child: Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                Color.fromARGB(255, 8, 90, 132), // Warna border
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 8, 90,
                                132), // Warna border saat dalam keadaan normal
                          ),
                        ),
                        suffixIcon: Icon(Icons.calendar_today,
                            color: Color.fromARGB(255, 8, 90, 132)),
                      ),
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 8, 90, 132),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hari',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 8, 90, 132),
              ),
            ),
            const SizedBox(height: 5.0),
            TextFormField(
              readOnly: true,
              controller: hariController,
              decoration: const InputDecoration(
                labelText: 'Masukkan Hari',
                labelStyle: TextStyle(color: Color.fromARGB(255, 8, 90, 132)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 8, 90, 132), // Warna border
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 8, 90,
                        132), // Warna border saat dalam keadaan normal
                  ),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _addSimpanJadwalDokter();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 8, 90,
                        132), // Warna latar biru tua untuk tombol "Simpan"
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                        color: Colors
                            .white), // Warna teks putih untuk kontras pada latar biru tua
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        Colors.red, // Warna latar merah untuk tombol "Batal"
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                        color: Colors
                            .white), // Warna teks putih untuk kontras pada latar merah
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
