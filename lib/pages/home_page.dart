import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpresensi/services/homepage_authservice.dart';
import 'package:fpresensi/services/location_service.dart';
import 'package:fpresensi/services/notification_service.dart';
import 'package:fpresensi/widgets/attendance_history.dart';
import 'package:fpresensi/pages/setting_page.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? displayName;

  @override
  void initState() {
    super.initState();
    _loadDisplayName();
    // Mendengarkan notifikasi saat aplikasi aktif
    NotificationService().listenForMessages();
  }

  // Fungsi untuk memuat displayName
  Future<void> _loadDisplayName() async {
    displayName = await HomePageAuthService.getDisplayName();
    setState(() {});
  }

  // Logika presensi
  Future<void> _handleAttendance() async {
    try {
      // Validasi biometrik dan lokasi
      bool isAuthenticated =
          await HomePageAuthService.authenticateWithBiometrics();
      if (!isAuthenticated) {
        _showMessage('Autentikasi biometrik gagal', isError: true);
        return;
      }

      // Validasi lokasi
      Position position = await LocationService.getCurrentLocation();
      if (!LocationService.isInOfficeArea(position)) {
        _showMessage('Kamu berada di luar area lokasi kantor', isError: true);
        return;
      }

      // Simpan presensi ke Firebase
      await HomePageAuthService.saveAttendance(position);

      // Tampilkan notifikasi berhasil
      _showMessage('Presensi berhasil disimpan!');
    } catch (e) {
      _showMessage('Terjadi kesalahan: $e', isError: true);
    }
  }

  // Fungsi untuk menampilkan pesan
  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error : Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.blue[500],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Deteksi tema (light mode atau dark mode)
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        // Ubah perilaku navigasi kembali di sini
        bool backButtonResult = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Konfirmasi',
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
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[300],
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: isDarkMode ? Colors.grey[850] : Colors.grey[300],
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0), // Tambahkan jarak di kiri
                        child: Image.asset('assets/images/fpresensilogo.png',
                            height: 35),
                      ),
                      const SizedBox(width: 10), // Jarak antara gambar dan teks
                      Text(
                        'F Presensi',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[500],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings,
                        color: Color.fromARGB(255, 90, 90, 90)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SettingPage(),
                      ));
                    },
                    padding: const EdgeInsets.only(
                        right: 16.0), // Jarak ke sisi kanan
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.blue[500],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Riwayat Presensi :",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const AttendanceHistory(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _handleAttendance,
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
          child: const Icon(
            Icons.fingerprint,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
