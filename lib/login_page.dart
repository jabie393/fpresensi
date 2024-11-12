import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpresensi/home_page.dart';
import 'package:fpresensi/register_page.dart';
import 'package:fpresensi/auth_service.dart'; // Import AuthService

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService(); // Instance AuthService
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;

  Future<void> _login() async {
    String? result = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
//
    if (result != null && result.isNotEmpty && result != 'null') {
      // Jika berhasil login (UID tidak kosong atau null), navigasi ke HomePage dan tampilkan pesan berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selamat datangggg!."),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Menampilkan pesan kesalahan jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Login gagal. Silakan periksa email dan kata sandi Anda.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // fungsi ketika tombol back ditekan maka akan keluar dari aplikasi
    // ignore: deprecated_member_use
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
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image(
                        image: AssetImage('assets/images/splash.png'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text("F PRESENSI",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[500],
                        )),
                  ),
                  const SizedBox(height: 20),
                  const Center(child: Text("LOGIN")),
                  const SizedBox(height: 20),
                  const Text("Email"),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan email anda',
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.blue[50],
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blue.shade500, width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  const Text("Password"),
                  TextField(
                    controller: _passwordController,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      hintText: 'Masukkan password anda',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscured ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscured = !_isObscured;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.blue[50],
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blue.shade500, width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue[500],
                      ),
                      child: const Text("Masuk"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: Text("Belum punya akun? Register",
                          style: TextStyle(
                            color: Colors.green[800],
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
