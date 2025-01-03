import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpresensi/pages/login_page.dart';
import 'package:fpresensi/pages/home_page.dart';
import 'package:fpresensi/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      home: isLoggedIn
          ? const HomePage() // Halaman Home jika sudah login
          : const LoginPage(), // Halaman Login jika belum login
    );
  }
}
