import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpresensi/pages/home_page.dart';
import 'package:fpresensi/pages/register_page.dart';
import 'package:fpresensi/services/auth_service.dart'; // Import AuthService
import 'package:fpresensi/widgets/custom_text_field.dart'; // Import widget untuk text field

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

    if (result != null && result.isNotEmpty && result != 'null') {
      // Jika berhasil login (UID tidak kosong atau null), navigasi ke HomePage dan tampilkan pesan berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selamat datang!"),
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
    return WillPopScope(
      onWillPop: () async {
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
                  SystemNavigator
                      .pop(); // Menggunakan SystemNavigator untuk keluar
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
                    child: Text(
                      "F PRESENSI",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[500],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(child: Text("LOGIN")),
                  const SizedBox(height: 20),
                  const Text("Email"),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Masukkan email anda',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  const Text("Password"),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Masukkan password anda',
                    icon: Icons.lock,
                    obscureText: _isObscured,
                    onSuffixIconPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
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
                      child: Text(
                        "Belum punya akun? Register",
                        style: TextStyle(
                          color: Colors.green[800],
                        ),
                      ),
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
