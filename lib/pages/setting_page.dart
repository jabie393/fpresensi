import 'package:flutter/material.dart';
import 'package:fpresensi/services/auth_service.dart'; // Import AuthService
import 'package:fpresensi/widgets/setting_button.dart'; // Import widget untuk tombol pengaturan
import 'package:fpresensi/pages/login_page.dart'; // Import halaman login

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final AuthService authService = AuthService(); // Instance AuthService

  final List<String> buttonTitles = [
    'Keluar', // Daftar tombol dengan judul
  ];

  final List<IconData> buttonIcons = [
    Icons.logout, // Ikon untuk tombol
  ];

  // Fungsi untuk konfirmasi logout
  Future<void> _confirmLogout() async {
    // Menampilkan dialog konfirmasi logout
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Konfirmasi Logout",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Apakah kamu yakin ingin keluar?",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue[300],
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Batal
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red[800],
              ),
              child: const Text("Tidak"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Ya
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue[600],
              ),
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );

    // Jika pengguna memilih "Ya", lakukan logout
    if (confirm == true) {
      await authService.logout(); // Logout menggunakan AuthService

      // Navigasi ke halaman Login setelah logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );

      // Tampilkan Snackbar setelah logout berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              SizedBox(width: 10), // Spasi antara ikon dan teks
              Expanded(
                child: Text(
                  "Kamu berhasil keluar!",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue[500],
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.grey[300],
      ),
      backgroundColor: Colors.grey[300],
      body: ListView.builder(
        itemCount: buttonTitles.length, // Jumlah tombol
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SettingButton(
              onPressed: _confirmLogout, // Panggil fungsi konfirmasi logout
              icon: buttonIcons[index], // Ikon tombol
              title: buttonTitles[index], // Judul tombol
            ),
          );
        },
      ),
    );
  }
}
