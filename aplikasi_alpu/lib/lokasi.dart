import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class LokasiPage extends StatefulWidget {
  const LokasiPage({Key? key});

  @override
  State<LokasiPage> createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi'),
        backgroundColor: Color.fromARGB(255, 8, 100, 146),
      ),
      body: Stack(
        children: [
          OpenStreetMapSearchAndPick(
            center: LatLong(1.0505349054912825, 103.96780703253478),
            buttonColor: Color.fromARGB(255, 8, 100, 146),
            buttonText: 'Set Current Location',
            onPicked: (pickedData) {
              print(pickedData.latLong.latitude);
              print(pickedData.latLong.longitude);
              print(pickedData.address);
            },
          ),
          Positioned(
            top: 20.0,
            right: 20.0,
            child: Image.asset(
              'assets/images/rs_embung.jpg', // Ubah path sesuai dengan lokasi gambar rumah sakit Anda
              width: 40.0,
              height: 40.0,
            ),
          ),
        ],
      ),
    );
  }
}
