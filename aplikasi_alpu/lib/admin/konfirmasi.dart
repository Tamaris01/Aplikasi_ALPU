import 'dart:convert';
import 'package:alpu_pbl/main.dart';
import 'package:alpu_pbl/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KehadiranPage extends StatefulWidget {
  const KehadiranPage({Key? key}) : super(key: key);

  @override
  State<KehadiranPage> createState() => _KehadiranPageState();
}

class _KehadiranPageState extends State<KehadiranPage> {
  List<Map<String, dynamic>> _listData = [];
  bool _isLoading = false;
  String _searchQuery = '';

  Future _getData() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/layanan/read.php'));
      if (response.statusCode == 200) {
        final List<dynamic> data =
            jsonDecode(response.body); // Ubah ke List<dynamic>
        // Konversi List<dynamic> ke List<Map<String, dynamic>>
        final List<Map<String, dynamic>> dataList =
            List<Map<String, dynamic>>.from(data);

        setState(() {
          _listData = dataList;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  List<dynamic> get _filteredData {
    return _listData.where((data) {
      final nama_poliklinik = data['nama_poliklinik'].toString().toLowerCase();
      return nama_poliklinik.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  String splitPoliName(String poliName) {
    List<String> words = poliName.split(' ');

    if (words.length > 3) {
      return words.sublist(0, 2).join(' ') + '\n' + words.sublist(2).join(' ');
    } else {
      return poliName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Konfirmasi Kehadiran Pasien",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF06628A),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            navigatorKey.currentState?.pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari  Poliklinik...',
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
                labelText: 'Cari Poliklinik...',
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
          ),
          // Grid view of cards
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _filteredData.isEmpty
                    ? Center(
                        child: Text('Data tidak ditemukan.'),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 6.0,
                          crossAxisSpacing: 5.0,
                        ),
                        itemCount: _filteredData.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.all(20.0),
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                color: Color(0xFF06628A),
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          splitPoliName(_filteredData[index]
                                              ['nama_poliklinik']),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        _filteredData[index]['foto_rs'] != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                child: Image.network(
                                                  '$baseUrl/api/layanan/images/${_filteredData[index]['foto_rs']}',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    print(
                                                        'Error loading image: $error');
                                                    return Container(); // Return an empty container or placeholder image
                                                  },
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            KonfirmasiKehadiran(
                                          poliData: {
                                            "id_poliklinik":
                                                _filteredData[index]
                                                    ['id_poliklinik'],
                                            "nama_poliklinik":
                                                _filteredData[index]
                                                    ['nama_poliklinik'],
                                          },
                                        ),
                                      ),
                                    );
                                    _getData();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF06628A),
                                  ),
                                  child: Text(
                                    'Konfirmasi Kehadiran',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class KonfirmasiKehadiran extends StatefulWidget {
  final Map poliData;
  const KonfirmasiKehadiran({Key? key, required this.poliData})
      : super(key: key);

  @override
  State<KonfirmasiKehadiran> createState() => _KonfirmasiKehadiranState();
}

class _KonfirmasiKehadiranState extends State<KonfirmasiKehadiran> {
  List<Map<String, dynamic>> _listData = [];
  String _searchQuery = '';
  var _isLoading = false;
  Future _getData() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      final url =
          '$baseUrl/api/kehadiran/readkehadiran.php?id_poliklinik=${widget.poliData['id_poliklinik']}';
      final response = await http.get(Uri.parse(url));
      if (!response.body.startsWith('[')) {
        throw (response.body);
      }
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> dataList =
            List<Map<String, dynamic>>.from(data);

        _listData = dataList;
        _isLoading = false;
      } else {
        _listData = [];
        _isLoading = false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

      _listData = [];
      _isLoading = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<bool> _updateStatus(String idPendaftaran, String newStatus) async {
    try {
      final pref = await PreferencesUtil.getInstance();
      final idAdmin = pref?.getString(PreferencesUtil.userId);
      final response = await http.post(
        Uri.parse('$baseUrl/api/kehadiran/statushadir.php'),
        body: {
          'id_pendaftaran': idPendaftaran,
          'status': newStatus,
          'id_admin': idAdmin,
        },
      );
      debugPrint(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['pesan'] == 'sukses') {
          print('Status berhasil diubah');
          _getData();
          return true;
        } else {
          print('Gagal mengubah status: ${data['error']}');
          return false;
        }
      } else {
        print('Error ${response.statusCode}: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Exception during status update: $e');
      return false;
    }
  }

  List<dynamic> get _filteredData {
    return _listData.where((data) {
      final nama_lengkap = data['nama_lengkap'].toString().toLowerCase();
      return nama_lengkap.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.poliData['nama_poliklinik'].toUpperCase()}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.5,
          ),
        ),
        backgroundColor: Color(0xFF06628A),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
            size: 37.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari  Poliklinik...',
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
                labelText: 'Cari Pasien...',
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
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _filteredData.isEmpty
                    ? Center(
                        child: Text('Data tidak ditemukan.'),
                      )
                    : ListView.builder(
                        itemCount: _filteredData.length,
                        itemBuilder: (context, index) {
                          final dataPasien = _filteredData[index];
                          final fotoPasien = dataPasien['foto'] ?? '';
                          Color cardColor = index % 2 == 0
                              ? Color(0xFFBAE7FB)
                              : Color(0xFFC6F6F6);
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                color: Color(0XFF097DAE),
                                width: 3.0,
                              ),
                            ),
                            margin: EdgeInsets.all(10),
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: cardColor,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      child: fotoPasien.isEmpty
                                          ? Image.asset(
                                              'assets/orang.png',
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              '$baseUrl/api/pasien/images/$fotoPasien'),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Text(
                                          'Pilih Konfirmasi',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 27,
                                            height: 27,
                                            decoration: BoxDecoration(
                                              color: Color(0XFFC6F6F6),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                // Show the popup here
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SimpleDialog(
                                                      elevation: 20,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                      ),
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          child: Text(
                                                            "Apakah anda yakin ingin konfirmasi dengan status 'Hadir'?",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                // Handle confirmation action
                                                                _updateStatus(
                                                                        "${dataPasien['id_pendaftaran']}",
                                                                        "hadir")
                                                                    .then(
                                                                        (value) {
                                                                  if (value) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            const Text(
                                                                          'Konfirmasi Hadir berhasil disimpan!',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        behavior:
                                                                            SnackBarBehavior.floating,
                                                                        backgroundColor: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            76,
                                                                            175,
                                                                            153),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            const Text(
                                                                          'Data Gagal Diubah!',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        behavior:
                                                                            SnackBarBehavior.floating,
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                      ),
                                                                    );
                                                                  }
                                                                });
                                                              },
                                                              style: TextButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    Color(
                                                                        0XFF097DAE),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        35,
                                                                    vertical:
                                                                        15),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  side: const BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              child: const Text(
                                                                  'Iya'),
                                                            ),
                                                            const SizedBox(
                                                                width: 20),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              style: TextButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    Color(
                                                                        0XFFFA281B),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        35,
                                                                    vertical:
                                                                        15),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  side: const BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              child: const Text(
                                                                  'Batal'),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Icon(
                                                Icons.check_outlined,
                                                color: Colors.green,
                                                size: 23,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Container(
                                            width: 27,
                                            height: 27,
                                            decoration: BoxDecoration(
                                              color: Color(0XFFF5DAD8),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                // Show the popup here
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SimpleDialog(
                                                      elevation: 20,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0),
                                                      ),
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          child: Text(
                                                            "Apakah anda yakin ingin konfirmasi dengan status 'Tidak Hadir'?",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                // Handle confirmation action
                                                                Navigator.pop(
                                                                    context);
                                                                _updateStatus(
                                                                        "${dataPasien['id_pendaftaran']}",
                                                                        "tidak_hadir")
                                                                    .then(
                                                                        (value) {
                                                                  if (value) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            const Text(
                                                                          'Konfirmasi Tidak Hadir Berhasil disimpan!',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        behavior:
                                                                            SnackBarBehavior.floating,
                                                                        backgroundColor:
                                                                            Colors.green,
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            const Text(
                                                                          'Data Gagal Diubah!',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        behavior:
                                                                            SnackBarBehavior.floating,
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                      ),
                                                                    );
                                                                  }
                                                                });
                                                              },
                                                              style: TextButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    Color(
                                                                        0XFF097DAE),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        35,
                                                                    vertical:
                                                                        15),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  side: const BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              child: const Text(
                                                                  'Iya'),
                                                            ),
                                                            const SizedBox(
                                                                width: 20),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              style: TextButton
                                                                  .styleFrom(
                                                                backgroundColor:
                                                                    Color(
                                                                        0XFFFA281B),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        35,
                                                                    vertical:
                                                                        15),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                  side: const BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              child: const Text(
                                                                  'Batal'),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.red,
                                                size: 23,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Nama: ${_filteredData[index]['nama_lengkap_pasien']}',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'NIK: ${_filteredData[index]['nik']}',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Dokter: ${_filteredData[index]['nama_lengkap_dokter']}',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                      SizedBox(height: 20),
                                    ],
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
    );
  }
}
