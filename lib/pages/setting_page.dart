import 'package:flutter/material.dart';
import 'package:fpresensi/services/auth_service.dart';
import 'package:fpresensi/widgets/setting_button.dart';
import 'package:fpresensi/pages/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final AuthService authService = AuthService(); // Instance AuthService

  final List<String> buttonTitles = [
    'Keluar',
    'Kontak Admin',
  ];

  final List<IconData> buttonIcons = [
    Icons.logout,
    Icons.contact_support_outlined,
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

  // admin Kontak untuk Fungsi
  Future<void> _contactAdmin() async {
    const String adminPhone = '6285812007371';
    final Uri whatsappUrl =
        Uri.parse("https://wa.me/$adminPhone?text=Halo%20Admin");

    // Periksa apakah intent WhatsApp biasa dapat diluncurkan
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      // Fallback untuk WhatsApp Business
      final Uri whatsappBusinessIntent = Uri.parse(
          "intent://send?phone=$adminPhone&text=Halo%20Admin#Intent;scheme=whatsapp;package=com.whatsapp.w4b;end");
      if (await canLaunchUrl(whatsappBusinessIntent)) {
        await launchUrl(whatsappBusinessIntent,
            mode: LaunchMode.externalApplication);
      } else {
        // Jika kedua pendekatan gagal, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal membuka WhatsApp atau WhatsApp Business'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Fungsi lain

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[500],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[300],
      body: Container(
        decoration: BoxDecoration(
          borderRadius:
              const BorderRadius.only(bottomRight: Radius.circular(30)),
          color: Colors.blue[500],
        ),
        margin: const EdgeInsets.only(bottom: 645),
        child: ListView.builder(
          itemCount: buttonTitles.length, // Jumlah tombol
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(0),
              child: SettingButton(
                onPressed: () {
                  if (buttonTitles[index] == 'Keluar') {
                    _confirmLogout(); // Panggil fungsi konfirmasi logout
                  } else if (buttonTitles[index] == 'Kontak Admin') {
                    _contactAdmin(); // Panggil fungsi kontak admin
                  }
                },
                icon: buttonIcons[index], // Ikon tombol
                title: buttonTitles[index], // Judul tombol
              ),
            );
          },
        ),
      ),
    );
  }
}
