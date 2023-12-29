import 'package:alpu_pbl/main.dart';
import 'package:alpu_pbl/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';

class KelolaPoliklinikPage extends StatelessWidget {
  const KelolaPoliklinikPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Poliklinik(),
    );
  }
}

class Poliklinik extends StatefulWidget {
  Poliklinik({Key? key}) : super(key: key);

  @override
  State<Poliklinik> createState() => _PoliklinikState();
}

class _PoliklinikState extends State<Poliklinik> {
  List<Map<String, dynamic>> _listData = [];

  bool _isLoading = false;
  String _searchQuery = '';

  Future _getData() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/layanan/read_for_admin.php'));
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
    super.initState();
    _getData();
  }

  String splitPoliName(String poliName) {
    List<String> words = poliName.split(' ');

    if (words.length > 3) {
      // Jika lebih dari 3 kata, gabungkan dua baris pertama
      return words.sublist(0, 2).join(' ') + '\n' + words.sublist(2).join(' ');
    } else {
      // Jika 3 kata atau kurang, kembalikan string asli
      return poliName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kelola Poliklinik",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF06628A),
        leading: IconButton(
          icon: const Icon(
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
                labelText: 'Cari Poliklinik...',
                labelStyle: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16.0,
                ),
              ),
              style: const TextStyle(
                color: Color.fromARGB(255, 8, 90, 132),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          // Grid view of cards
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _filteredData.isEmpty
                    ? const Center(
                        child: Text('Data tidak ditemukan.'),
                      )
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 6.0,
                          crossAxisSpacing: 5.0,
                        ),
                        itemCount: _filteredData.length,
                        itemBuilder: (context, index) {
                          final status = _filteredData[index]['status'];
                          return Card(
                            margin: const EdgeInsets.all(20.0),
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: const BorderSide(
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
                                      children: <Widget>[
                                        Text(
                                          splitPoliName(_filteredData[index]
                                              ['nama_poliklinik']),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        _filteredData[index]['foto_logo'] !=
                                                null
                                            ? Image.network(
                                                '$baseUrl/api/layanan/images/${_filteredData[index]['foto_logo']}',
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  print(
                                                      'Error loading image: $error');
                                                  return Container(); // Return an empty container or placeholder image
                                                },
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                                // Add spacing between ListTile and button
                                ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailDataPage(
                                          poliData: {
                                            "id_poliklinik":
                                                _filteredData[index]
                                                    ['id_poliklinik'],
                                            "nama_poliklinik":
                                                _filteredData[index]
                                                    ['nama_poliklinik'],
                                            "detail": _filteredData[index]
                                                ['detail'],
                                            "foto_rs": _filteredData[index]
                                                ['foto_rs'],
                                            "foto_logo": _filteredData[index]
                                                ['foto_logo'],
                                            "status": _filteredData[index]
                                                ['status'],
                                          },
                                        ),
                                      ),
                                    );
                                    _getData();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        const Color.fromARGB(255, 7, 108, 167),
                                  ),
                                  child: const Text(
                                    'Detail',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(status == '0' ? 'nonaktif' : 'aktif'),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 4, 68, 100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahDataPage(),
            ),
          );
        },
      ),
    );
  }
}

class DetailDataPage extends StatefulWidget {
  final Map poliData;
  const DetailDataPage({Key? key, required this.poliData}) : super(key: key);

  @override
  State<DetailDataPage> createState() => _DetailDataPageState();
}

class _DetailDataPageState extends State<DetailDataPage> {
  List<Map<String, dynamic>> _listData = [];
  // bool _isLoading = true;
  // List _images = [];
  int index = 0;

//=============================================================
  File? pictureFile;
  File? pictureFileTwo;
//=============================================================

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

  Future<bool> _hapus(String id) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/api/layanan/delete.php'), body: {
        "id_poliklinik": id,
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final status = data['status'];

        if (status == 'sukses') {
          // Jika operasi berhasil
          setState(() {});
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  TextEditingController id_poli = TextEditingController();
  TextEditingController nama_poli = TextEditingController();
  TextEditingController detail = TextEditingController();

  Future _update(File pictureFile, File pictureFileTwo) async {
    try {
      var uri = Uri.parse("$baseUrl/api/layanan/edit.php");
      var request = http.MultipartRequest("POST", uri);

      if (pictureFile.existsSync()) {
        var pictureFileStream =
            http.ByteStream(DelegatingStream(pictureFile.openRead()));
        var pictureFileLength = await pictureFile.length();
        var pictureFileMultipartFile = http.MultipartFile(
          "foto_rs",
          pictureFileStream,
          pictureFileLength,
          filename: basename(pictureFile.path),
        );
        request.files.add(pictureFileMultipartFile);
      }

      if (pictureFileTwo.existsSync()) {
        var pictureFileTwoStream =
            http.ByteStream(DelegatingStream(pictureFileTwo.openRead()));
        var pictureFileTwoLength = await pictureFileTwo.length();
        var pictureFileTwoMultipartFile = http.MultipartFile(
          "foto_logo",
          pictureFileTwoStream,
          pictureFileTwoLength,
          filename: basename(pictureFileTwo.path),
        );
        request.files.add(pictureFileTwoMultipartFile);
      }

      request.fields['id_poliklinik'] = id_poli.text;
      request.fields['nama_poliklinik'] = nama_poli.text;
      request.fields['detail'] = detail.text;

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Update Success');

        // Setelah pembaruan berhasil, perbarui UI untuk menampilkan gambar yang baru diunggah
        setState(() {
          // Gantilah file gambar pada UI dengan yang baru diunggah
          // Misalnya, jika menggunakan variable state 'pictureFile', Anda dapat menggantinya dengan yang baru diunggah
          pictureFile = File(pictureFile.path);
          pictureFileTwo = File(pictureFileTwo.path);
        });

        return true;
      } else {
        print('Update Failed: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error during update: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    id_poli.text = widget.poliData['id_poliklinik'];
    nama_poli.text = widget.poliData['nama_poliklinik'];
    detail.text = widget.poliData['detail'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return FlexibleSpaceBar(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  "${widget.poliData['nama_poliklinik'].toUpperCase()}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
        backgroundColor: const Color(0xFF06628A),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "edit") {
                index = _listData.indexWhere(
                    (item) => item['id_poliklinik'] == id_poli.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditDataPage(
                      ListData: {
                        "id_poliklinik": _listData[index]['id_poliklinik'],
                        "nama_poliklinik": _listData[index]['nama_poliklinik'],
                        "detail": _listData[index]['detail'],
                        "foto_rs": _listData[index]['foto_rs'],
                        "foto_logo": _listData[index]['foto_logo'],
                      },
                    ),
                  ),
                );
              } else if (value == "status") {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      content: Text(
                        'Ubah status ${widget.poliData['nama_poliklinik']}?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _updateStatusKeaktifan(
                                    navigatorKey.currentContext!);
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (widget.poliData['status'] == '0') {
                                      return const Color(0xFFFA281B);
                                    }
                                    return const Color.fromARGB(
                                        255, 8, 90, 132);
                                  },
                                ),
                              ),
                              child: Text(
                                widget.poliData['status'] == '0'
                                    ? 'AKTIFKAN'
                                    : 'NONAKTIFKAN',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              }
            },
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white, // Set the color to white
            ),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: "edit",
                child: Text("Ubah Data"),
              ),
              const PopupMenuItem<String>(
                value: "status",
                child: Text("Ubah status"),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan gambar foto_rs
            Padding(
              padding: const EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: () {
                  var imageUrl = widget.poliData['foto_rs'];
                  var completeImageUrl =
                      '$baseUrl/api/layanan/images/$imageUrl';
                  print('Complete Image URL: $completeImageUrl');

                  return imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(completeImageUrl)
                      : Container();
                }(),
              ),
            ),
            const SizedBox(height: 1),
            Card(
              elevation: 4,
              margin: const EdgeInsets.all(15),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          nama_poli.text,
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                detail.text,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        )
                      ])),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _updateStatusKeaktifan(BuildContext context) async {
    final newStatus = widget.poliData['status'] == '0' ? '1' : '0';
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/poliklinik/update_status.php"),
        body: {
          'id_poliklinik': widget.poliData['id_poliklinik'],
          'status': newStatus,
        },
      );
      if (mounted) {
        if (response.statusCode == 200) {
          widget.poliData['status'] = newStatus;
          _alert(context, 'Berhasil mengubah status!');
        } else {
          _alert(context, 'Gagal mengubah status data');
        }
      }
    } catch (e) {
      if (mounted) _alert(context, e.toString());
    }
  }

  _alert(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(message),
          );
        });
  }
}

class TambahDataPage extends StatefulWidget {
  const TambahDataPage({Key? key}) : super(key: key);

  @override
  State<TambahDataPage> createState() => _TambahDatPageState();
}

class _TambahDatPageState extends State<TambahDataPage> {
  final _formKey = GlobalKey<FormState>();

  // ignore: unused_field
  // List _images = [];

  TextEditingController id_poli = TextEditingController();
  TextEditingController nama_poli = TextEditingController();
  TextEditingController detail = TextEditingController();

  //=============================================================
  File? pictureFile;
  File? pictureFileTwo;
//=============================================================
  Future _imageCamera1() async {
    try {
      var imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (imageFile == null) return;
      var pictureTemp = File(imageFile.path);

      setState(() {
        pictureFile = File(pictureTemp.path);
      });
    } on PlatformException catch (e) {
      print('Gagal Memilih Gambar: $e');
    }
  }

  Future _imageGallery1() async {
    try {
      var imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile == null) return;
      var pictureTemp = File(imageFile.path);

      setState(() {
        pictureFile = File(pictureTemp.path);
      });
    } on PlatformException catch (e) {
      print('Gagal Memilih Gambar: $e');
    }
  }

//=============================================================

  Future _imageCamera2() async {
    try {
      var imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (imageFile == null) return;
      var pictureTemp = File(imageFile.path);

      setState(() {
        if (pictureFile == null) {
          pictureFile = File(pictureTemp.path);
        } else {
          pictureFileTwo = File(pictureTemp.path);
        }
      });
    } on PlatformException catch (e) {
      print('Gagal Memilih Gambar: $e');
    }
  }

  Future _imageGallery2() async {
    try {
      var imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile == null) return;
      var pictureTemp = File(imageFile.path);

      setState(() {
        if (pictureFile == null) {
          pictureFile = File(pictureTemp.path);
        } else {
          pictureFileTwo = File(pictureTemp.path);
        }
      });
    } on PlatformException catch (e) {
      print('Gagal Memilih Gambar: $e');
    }
  }

  //=============================================================

  Future _simpan(File imageFile) async {
    final pref = await PreferencesUtil.getInstance();
    final idAdmin = pref?.getString(PreferencesUtil.userId) ?? '';
    var stream = http.ByteStream(DelegatingStream(imageFile.openRead()));
    var length = await imageFile.length();
    if (length > 1024 * 1024) {
      const snackBar = SnackBar(
        content: Text('Ukuran foto tidak boleh lebih dari 1MB!'),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      return;
    }
    var uri = Uri.parse("$baseUrl/api/layanan/create.php");
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile("foto_rs", stream, length,
        filename: basename(imageFile.path));
    request.fields['id_admin'] = idAdmin;
    request.fields['id_poliklinik'] = id_poli.text;
    request.fields['nama_poliklinik'] = nama_poli.text;
    request.fields['detail'] = detail.text;
    request.files.add(multipartFile);

    // Tambahkan parameter untuk gambar kedua
    if (pictureFileTwo != null) {
      var streamTwo =
          http.ByteStream(DelegatingStream(pictureFileTwo!.openRead()));
      var lengthTwo = await pictureFileTwo!.length();
      var multipartFileTwo = http.MultipartFile(
          "foto_logo", streamTwo, lengthTwo,
          filename: basename(pictureFileTwo!.path));
      request.files.add(multipartFileTwo);
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var jsonResponse = await response.stream.bytesToString();
      debugPrint(jsonResponse);
      var data = json.decode(jsonResponse);

      if (data['pesan'] == 'sukses') {
        print('Upload Success');
        print('URL RS: ${data['url_rs']}');
        print('URL Logo: ${data['url_logo']}');
        // Lakukan sesuatu dengan URL path yang dikembalikan, misalnya, tampilkan di UI.
      } else {
        throw (data['pesan']);
      }
    } else {
      throw ('Gagal response code ${response.statusCode}');
    }
  }

  //=============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Tambah Poliklinik",
          style: TextStyle(
            color: Colors.white, // Set title color to white
          ),
        ),
        backgroundColor:
            const Color(0xFF06628A), // Set appbar color to #0xFF06628A
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 30.0),
                Card(
                  elevation: 8.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(5.0), // Bentuk ujung card
                    side: const BorderSide(
                        color: Color.fromARGB(255, 8, 110, 154),
                        width: 3.0), // Warna dan lebar border
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Tambah Poliklinik',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                  ),
                                ),
                                SizedBox(width: 5),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          TextFormField(
                            controller: id_poli,
                            decoration: const InputDecoration(
                              labelText: 'ID Poliklinik :',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Tidak Boleh Kosong";
                              } else if (value.length > 10) {
                                return "Maksimal 10 huruf";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 30.0),
                          TextFormField(
                            key: const Key('nama_poli'),
                            controller: nama_poli,
                            decoration: const InputDecoration(
                              labelText: 'Nama Poliklinik :',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Detail Poliklinik Tidak Boleh Kosong";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 30.0),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  "Foto Poliklinik : ",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                pictureFile != null
                                    ? Expanded(
                                        child: Text(
                                          basename(pictureFile!.path),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.photo_camera),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.photo_camera_outlined),
                                              title: const Text(
                                                  'Ambil Gambar dari Kamera'),
                                              onTap: () {
                                                _imageCamera1();
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.photo_library_rounded),
                                              title: const Text(
                                                  'Pilih Gambar dari Galeri'),
                                              onTap: () {
                                                _imageGallery1();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  "Logo Poliklinik : ",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                pictureFileTwo != null
                                    ? Expanded(
                                        child: Text(
                                          basename(pictureFileTwo!.path),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.photo_camera),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.photo_camera_outlined),
                                              title: const Text(
                                                  'Ambil Gambar dari Kamera'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _imageCamera2();
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.photo_library_rounded),
                                              title: const Text(
                                                  'Pilih Gambar dari Galeri'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _imageGallery2();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          TextFormField(
                            controller: detail,
                            decoration: const InputDecoration(
                              labelText: 'Detail :',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Detail Poliklinik Tidak Boleh Kosong";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 30.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  // Kode untuk membatalkan operasi
                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                      255,
                                      205,
                                      50,
                                      38), // Warna latar belakang merah
                                ),
                                child: const Text(
                                  'Batal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // Warna teks putih
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8), // Jarak antara tombol
                              ElevatedButton(
                                onPressed: () async {
                                  print('Foto Berhasil Di Simpan');
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      if (pictureFile != null) {
                                        await _simpan(pictureFile!);
                                      }

                                      const snackBar = SnackBar(
                                        content: Text(
                                          'Data Berhasil Di Simpan!',
                                          style: TextStyle(
                                            color: Colors
                                                .white, // Set the text color to white
                                          ),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor:
                                            Color.fromARGB(236, 90, 202, 157),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);

                                      // Navigasi ke halaman beranda
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Poliklinik()),
                                        (route) => false,
                                      );
                                    } catch (error) {
                                      print('Error: $error');
                                      final snackBar = SnackBar(
                                        content: Text(
                                          error.toString(),
                                          style: TextStyle(
                                            color: Colors
                                                .white, // Set the text color to white
                                          ),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor:
                                            Color.fromARGB(255, 215, 50, 38),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: const Color.fromARGB(
                                      255, 6, 82, 133), // Warna biru tua
                                ),
                                child: const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // Warna teks putih
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}

class EditDataPage extends StatefulWidget {
  final Map ListData;

  const EditDataPage({Key? key, required this.ListData}) : super(key: key);

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController id_poli = TextEditingController();
  TextEditingController nama_poli = TextEditingController();
  TextEditingController detail = TextEditingController();
  TextEditingController foto_rs = TextEditingController();
  TextEditingController foto_logo = TextEditingController();

  File? pictureFile;
  File? pictureFileTwo;
//=============================================================
  Future _imageCamera1() async {
    try {
      var imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (imageFile == null) return;

      setState(() {
        pictureFile = File(imageFile.path);
      });
    } on PlatformException catch (e) {
      print('Gagal Memilih Gambar: $e');
    }
  }

  Future _imageGallery1() async {
    try {
      var imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile == null) return;

      setState(() {
        pictureFile = File(imageFile.path);
      });
    } on PlatformException catch (e) {
      print('Gagal Memilih Gambar: $e');
    }
  }

//=============================================================

  Future _imageCamera2() async {
    try {
      var imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (imageFile == null) return;

      setState(() {
        if (pictureFile == null) {
          pictureFile = File(imageFile.path);
        } else {
          pictureFileTwo = File(imageFile.path);
        }
      });
    } on PlatformException catch (e) {
      print('Gagal Memilih Gambar: $e');
    }
  }

  Future _imageGallery2() async {
    try {
      var imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile == null) return;

      setState(() {
        if (pictureFile == null) {
          pictureFile = File(imageFile.path);
        } else {
          pictureFileTwo = File(imageFile.path);
        }
      });
    } on PlatformException catch (e) {
      print('Gagal Memilih Gambar: $e');
    }
  }

//=============================================================

  Future _update(File pictureFile, File pictureFileTwo) async {
    try {
      final pref = await PreferencesUtil.getInstance();
      final idAdmin = pref?.getString(PreferencesUtil.userId) ?? "";
      var uri = Uri.parse("$baseUrl/api/layanan/edit.php");
      var request = http.MultipartRequest("POST", uri);

      bool isFileSizeValid(File file) {
        const int maxSizeInBytes = 1048576;
        // ignore: unnecessary_null_comparison
        if (file != null && file.existsSync()) {
          int fileSize = file.lengthSync();
          return fileSize <= maxSizeInBytes;
        }

        return true;
      }

      if (!isFileSizeValid(pictureFile) || !isFileSizeValid(pictureFileTwo)) {
        print('File size exceeds 1MB limit');
        // You can display a warning message or handle it as needed
        return false;
      }

      // ignore: unnecessary_null_comparison
      if (pictureFile != null && pictureFile.existsSync()) {
        var pictureFileStream =
            http.ByteStream(DelegatingStream(pictureFile.openRead()));
        var pictureFileLength = await pictureFile.length();
        var pictureFileMultipartFile = http.MultipartFile(
          "foto_rs",
          pictureFileStream,
          pictureFileLength,
          filename: basename(pictureFile.path),
        );
        request.files.add(pictureFileMultipartFile);
      }

      // ignore: unnecessary_null_comparison
      if (pictureFileTwo != null && pictureFileTwo.existsSync()) {
        var pictureFileTwoStream =
            http.ByteStream(DelegatingStream(pictureFileTwo.openRead()));
        var pictureFileTwoLength = await pictureFileTwo.length();
        var pictureFileTwoMultipartFile = http.MultipartFile(
          "foto_logo",
          pictureFileTwoStream,
          pictureFileTwoLength,
          filename: basename(pictureFileTwo.path),
        );
        request.files.add(pictureFileTwoMultipartFile);
      }

      request.fields['id_poliklinik'] = id_poli.text;
      request.fields['id_admin'] = idAdmin;
      request.fields['nama_poliklinik'] = nama_poli.text;
      request.fields['detail'] = detail.text;

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Update Success');
        return true;
      } else {
        print('Update Failed: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error during update: $error');
      return false;
    }
  }

//=============================================================

  @override
  void initState() {
    super.initState();
    id_poli.text = widget.ListData['id_poliklinik'] ?? '';
    nama_poli.text = widget.ListData['nama_poliklinik'] ?? '';
    detail.text = widget.ListData['detail'] ?? '';
    pictureFile = widget.ListData['foto_rs'] != null
        ? File(widget.ListData['foto_rs'])
        : null;
    pictureFileTwo = widget.ListData['foto_logo'] != null
        ? File(widget.ListData['foto_logo'])
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return FlexibleSpaceBar(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  "Ubah ${widget.ListData['nama_poliklinik']}",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
        backgroundColor: const Color(0xFF06628A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 5.0),
              Card(
                elevation: 8.0,
                color: const Color.fromARGB(255, 251, 251, 251),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: const BorderSide(color: Color(0XFF097DAE), width: 3.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Ubah Poliklinik',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          enabled: false,
                          controller: id_poli,
                          decoration: const InputDecoration(
                            labelText: 'ID Poliklinik :',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        TextFormField(
                          key: const Key('nama_poli'),
                          controller: nama_poli,
                          decoration: const InputDecoration(
                            labelText: 'Nama Poliklinik :',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(105, 0, 0, 0),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                "Foto Poliklinik : ",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              pictureFile != null
                                  ? Expanded(
                                      child: Text(
                                        basename(pictureFile!.path),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.photo_camera),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: const Icon(
                                                Icons.photo_camera_outlined),
                                            title: const Text(
                                                'Ambil Gambar dari Kamera'),
                                            onTap: () {
                                              _imageCamera1();
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                                Icons.photo_library_rounded),
                                            title: const Text(
                                                'Pilih Gambar dari Galeri'),
                                            onTap: () {
                                              _imageGallery1();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(height: 15.0),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(117, 0, 0, 0),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                "Logo Poliklinik : ",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              pictureFileTwo != null
                                  ? Expanded(
                                      child: Text(
                                        basename(pictureFileTwo!.path),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.photo_camera),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: const Icon(
                                                Icons.photo_camera_outlined),
                                            title: const Text(
                                                'Ambil Gambar dari Kamera'),
                                            onTap: () {
                                              _imageCamera2();
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                                Icons.photo_library_rounded),
                                            title: const Text(
                                                'Pilih Gambar dari Galeri'),
                                            onTap: () {
                                              _imageGallery2();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: detail,
                          decoration: const InputDecoration(
                            labelText: 'Detail:',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                        const SizedBox(height: 15.0),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 4.0), // Ruang di sebelah kanan Row
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  'Batal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8), // Jarak antara tombol
                              ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    _update(pictureFile!, pictureFileTwo!)
                                        .then((value) {
                                      if (value) {
                                        const snackBar = SnackBar(
                                          content: Text(
                                            'Data Berhasil Diubah!',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor:
                                              Color.fromARGB(255, 76, 175, 116),
                                        );

                                        // Panggil showSnackBar setelah data berhasil diubah
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);

                                        // Navigasi setelah menampilkan Snackbar
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Poliklinik()),
                                          (route) => false,
                                        );
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

                                        // Perhatikan bahwa kita memindahkan Navigator ke sini
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Poliklinik()),
                                          (route) => false,
                                        );
                                      }
                                    });
                                    // Jangan panggil Navigator di sini
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      const Color.fromARGB(255, 6, 71, 121),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 8.0),
                                  child: Text(
                                    'Simpan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
