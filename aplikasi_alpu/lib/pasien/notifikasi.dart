import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 8, 90, 132),
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  // Add navigation logic to the previous page
                },
              ),
              SizedBox(width: 8),
              Text(
                'NOTIFIKASI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: HomeScreen(sampleNotes),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final List<Note> notes;

  const HomeScreen(this.notes, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> filteredNotes = [];

  @override
  void initState() {
    super.initState();
    filteredNotes = widget.notes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 30),
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              return buildNotificationCard(filteredNotes[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget buildNotificationCard(Note note) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 3,
        color: const Color.fromARGB(
            255, 183, 222, 255), // Ubah warna latar belakang Card menjadi biru
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          leading: CircleAvatar(
              // You can replace this with the user's profile picture or any icon
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              child: Icon(
                Icons.notifications,
                color: Color.fromARGB(255, 0, 64, 117),
              )),
          title: Text(
            note.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                note.content,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'Tanggal kunjungan:\n${DateFormat('EEE MMM d, yyyy h:mm a').format(note.modifiedTime)}',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          trailing: Icon(Icons.more_vert),
        ),
      ),
    );
  }
}

class Note {
  int id;
  String title;
  String content;
  DateTime modifiedTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
  });
}

List<Note> sampleNotes = [
  Note(
    id: 0,
    title: 'PENGINGAT:',
    content: 'Jangan lupa kunjungi dokter!',
    modifiedTime: DateTime(2023, 1, 1, 34, 5),
  ),
  Note(
    id: 1,
    title: 'PENGINGAT:',
    content: 'Jangan lupa kunjungi dokter!',
    modifiedTime: DateTime(2022, 1, 1, 34, 5),
  ),
  Note(
    id: 2,
    title: 'PENGINGAT:',
    content: 'Jangan lupa kunjungi dokter!',
    modifiedTime: DateTime(2023, 3, 1, 19, 5),
  ),
  Note(
    id: 3,
    title: 'PENGINGAT:',
    content: 'Jangan lupa kunjungi dokter!',
    modifiedTime: DateTime(2023, 1, 4, 16, 53),
  ),
];
