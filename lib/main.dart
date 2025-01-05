import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpresensi/pages/login_page.dart';
import 'package:fpresensi/pages/home_page.dart';
import 'package:fpresensi/services/notification_service.dart';
import 'package:fpresensi/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi layanan notifikasi
  await NotificationService().initNotifications();

  // Menangani notifikasi ketika aplikasi berada di background
  FirebaseMessaging.onBackgroundMessage(
      NotificationService.backgroundMessageHandler);

  // Atur login berkelanjutan (Persistence.LOCAL)
  try {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    print('Login persistence diatur ke LOCAL');
  } catch (e) {
    print('Gagal mengatur login persistence: $e');
  }

  // Cek status login pengguna
  User? user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(isLoggedIn: user != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Tema default (terang)
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Tema gelap
        primarySwatch: Colors.blueGrey,
      ),
      themeMode: ThemeMode.system, // Menyesuaikan dengan tema sistem
      home: isLoggedIn
          ? const HomePage() // Halaman Home jika sudah login
          : const LoginPage(), // Halaman Login jika belum login
    );
  }
}
 