import 'package:flutter/material.dart';
import 'package:fpresensi/login_page.dart';
import 'package:fpresensi/auth_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final AuthService authService = AuthService();

  final List<String> buttonTitles = [
    'Keluar',
  ];
  final List<IconData> buttonIcons = [
    Icons.logout,
  ];

  Future<void> _confirmLogout() async {
    // Menampilkan dialog konfirmasi
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
              child: const Text(
                "Tidak",
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Ya
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue[600],
              ),
              child: const Text(
                "Ya",
              ),
            ),
          ],
        );
      },
    );

    // Jika pengguna memilih "Ya", lakukan logout
    if (confirm == true) {
      await authService.logout();

      // Navigasi ke halaman Login setelah logout
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );

      // Tampilkan Snackbar setelah logout berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Kamu berhasil Keluar!"),
          duration: Duration(seconds: 2),
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
        itemCount: buttonTitles.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _confirmLogout, // Panggil fungsi konfirmasi logout
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue[500],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(buttonIcons[index]),
              label: Text(buttonTitles[index]),
            ),
          );
        },
      ),
    );
  }
}
