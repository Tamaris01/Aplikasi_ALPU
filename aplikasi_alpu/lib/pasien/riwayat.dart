import 'dart:convert';
import 'package:alpu_pbl/main.dart';
import 'package:alpu_pbl/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:url_launcher/url_launcher.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final _riwayatList = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _fetchRiwayat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pendaftaran'),
        backgroundColor: const Color.fromARGB(255, 8, 90, 132),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PaginatedDataTable(
                header: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Data Pendaftaran',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: const Color.fromARGB(255, 8, 90, 132),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                rowsPerPage: 5,
                columnSpacing: 50,
                columns: const [
                  DataColumn(
                    label: Text(
                      'ID Pendaftaran',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 8, 90, 132),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Bukti',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 8, 90, 132),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                source: _DataSource(context, _riwayatList),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _fetchRiwayat() async {
    final pref = await PreferencesUtil.getInstance();
    final id = pref?.getString(PreferencesUtil.userId);
    final uri = Uri.parse("$baseUrl/api/pendaftaran/read.php?nik_pasien=$id");

    try {
      final response = await http.get(uri);
      debugPrint('response: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['data'] != null && (json['data'] as List).isNotEmpty) {
          _riwayatList.addAll(List<Map<String, dynamic>>.from(json['data']));
          setState(() {});
        } else {
          // Tampilkan pesan jika data riwayat kosong
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Informasi'),
                content: const Text('Tidak ada riwayat pendaftaran.'),
              );
            },
          );
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Gagal'),
              content: Text(e.toString()),
            );
          },
        );
      }
    }
  }
}

class _DataSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;

  final BuildContext context;

  _DataSource(this.context, this._data);

  @override
  DataRow getRow(int index) {
    final data = _data[index];
    return DataRow(cells: [
      DataCell(
        Text(
          "${data['id_pendaftaran']}",
          textAlign: TextAlign.center,
        ),
      ),
      DataCell(
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BuktiPendaftaranPage(
                noPendaftaran: "${data['id_pendaftaran']}",
                nik: "${data['nik_pasien']}",
                namaPasien: "${data['nama_pasien']}",
                poliklinik: "${data['nama_poliklinik']}",
                dokter: "${data['nama_dokter']}",
                tglHadir: "${data['tanggal_kunjungan']}",
              ),
            ));
          },
          child: const Text('Lihat'),
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}

class BuktiPendaftaranPage extends StatelessWidget {
  final String noPendaftaran;
  final String nik;
  final String namaPasien;
  final String poliklinik;
  final String dokter;
  final String tglHadir;

  BuktiPendaftaranPage({
    required this.noPendaftaran,
    required this.nik,
    required this.namaPasien,
    required this.poliklinik,
    required this.dokter,
    required this.tglHadir,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bukti Pendaftaran'),
        backgroundColor: const Color.fromARGB(255, 8, 90, 132),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Tombol Unduh
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _downloadRiwayat({
                      'noPendaftaran': noPendaftaran,
                      'nik': nik,
                      'namaPasien': namaPasien,
                      'poliklinik': poliklinik,
                      'dokter': dokter,
                      'tglHadir': tglHadir,
                    }, context);
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Unduh'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 8, 90, 132),
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Card untuk bukti pendaftaran dengan border biru
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Color.fromARGB(255, 8, 90, 132),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informasi Pendaftaran
                    Text(
                      'Nomor Pendaftaran: $noPendaftaran',
                      style: const TextStyle(
                        color: const Color.fromARGB(255, 8, 90, 132),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'NIK: $nik',
                      style: const TextStyle(
                        color: const Color.fromARGB(255, 8, 90, 132),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nama: $namaPasien',
                      style: const TextStyle(
                        color: const Color.fromARGB(255, 8, 90, 132),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Poliklinik: $poliklinik',
                      style: const TextStyle(
                        color: const Color.fromARGB(255, 8, 90, 132),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dokter: $dokter',
                      style: const TextStyle(
                        color: const Color.fromARGB(255, 8, 90, 132),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tanggal Hadir: $tglHadir',
                      style: const TextStyle(
                        color: const Color.fromARGB(255, 8, 90, 132),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Teks "Simpan bukti pendaftaran ini !" dalam container bukti pendaftaran paling bawah
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        'Simpan bukti pendaftaran ini !',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadRiwayat(Map<String, String> map, BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(8),
                  color: PdfColors.grey300, // Warna latar belakang kartu
                ),
                padding: pw.EdgeInsets.all(10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    pw.Text(
                      'Bukti Pendaftaran',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    pw.Divider(thickness: 2),
                    pw.SizedBox(height: 10),
                    // Konten dari bukti pendaftaran
                    for (final entry in map.entries)
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              _formatKey(entry.key),
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(entry.value),
                          ),
                        ],
                      ),
                    pw.Divider(thickness: 1),
                    pw.Container(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        'Simpan bukti pendaftaran ini !',
                        style: pw.TextStyle(
                          fontSize: 16,
                          color: PdfColor.fromInt(0xFFFF0000), // Warna merah
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    final fileName = "Riwayat_${DateTime.now().millisecondsSinceEpoch}.pdf";

    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/api/upload_pdf.php'));
    final multipartFile =
        http.MultipartFile.fromBytes('pdf', bytes, filename: fileName);
    request.files.add(multipartFile);
    final response = await request.send();
    final body = await response.stream.first;
    final responseString = utf8.decode(body);
    if (responseString != 'ok') {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (c) {
            return AlertDialog(
              title: const Text('Gagal'),
              content: Text(responseString),
            );
          },
        );
      }
      return;
    }
    final downloadUrl = "$baseUrl/api/download_pdf.php?file_name=$fileName";
    await launchUrl(Uri.parse(downloadUrl));
  }

  String _formatKey(String key) {
    // Memformat setiap kata untuk dimulai dengan huruf kapital
    List<String> words = key.split(' ');
    words = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return '';
      }
    }).toList();

    return words.join(' ');
  }
}
