import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpresensi/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Ubah perilaku navigasi kembali di sini
        bool backButtonResult = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue[300],
            content: const Text(
              'Apakah kamu ingin keluar?',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red[800],
                ),
                child: const Text('Tidak'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigasi keluar dari aplikasi
                  SystemNavigator.pop(); // Menggunakan SystemNavigator
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue[600],
                ),
                child: const Text('Ya'),
              ),
            ],
          ),
        );
        return backButtonResult;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Text('Presensi anda'),
          automaticallyImplyLeading:
              false, // menghilangkan tombol back di appbar
          backgroundColor: Colors.grey[300],
          actions: [
            IconButton(
              icon: const Icon(Icons.settings), // ikon setting
              iconSize: 30,
              padding: const EdgeInsets.only(right: 12),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const SettingPage()))
                    .then((value) {
                  setState(() {});
                });
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nama Pengguna", // Ganti dengan data atau widget lainnya sesuai kebutuhan
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '-', // memanggil hari, tanggal, dan tahun
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '-', // memanggil jam masuk
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  Text(
                                    "Masuk",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '-', // memanggil jam pulang
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  Text(
                                    "Pulang",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Riwayat Presensi"),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.grey[50],
          child: const Icon(
            Icons.location_on,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
