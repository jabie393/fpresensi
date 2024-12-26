import 'package:flutter/material.dart';
import 'package:fpresensi/services/auth_service.dart'; // Import AuthService
import 'package:fpresensi/widgets/custom_text_field.dart'; // Import widget untuk text field
import 'package:fpresensi/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService(); // Instance AuthService
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController =
      TextEditingController(); // Controller untuk nama pengguna
  bool _isObscured = true;

  Future<void> _register() async {
    String? result = await _authService.register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _displayNameController.text.trim(), // Mengirimkan nama pengguna
    );

    if (result != null && result.isNotEmpty && result != 'null') {
      // Tampilkan pesan kesalahan jika registrasi gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error,
                color: Colors.white,
              ),
              const SizedBox(width: 10), // Spasi antara ikon dan teks
              Expanded(
                child: Text(
                  result,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      // Jika berhasil, arahkan pengguna ke halaman login dan tampilkan pesan berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
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
                  "Berhasil membuat akun, silahkan login!",
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
      resizeToAvoidBottomInset:
          true, // Menyesuaikan tampilan saat keyboard muncul
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          // Memastikan konten di tengah layar
          child: SingleChildScrollView(
            // Membuat konten bisa di-scroll
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Agar hanya menyesuaikan ukuran konten
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image(
                        image: AssetImage('assets/images/fpresensilogo.png'),
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
                  const Center(child: Text("REGISTER")),
                  const SizedBox(height: 20),
                  const Text("Nama Pengguna"),
                  CustomTextField(
                    controller: _displayNameController,
                    hintText: 'Masukkan nama lengkap',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  const Text("Email"),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'example@mail.com',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  const Text("Password"),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Harus 6 karakter atau lebih',
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
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue[500],
                      ),
                      child: const Text("Daftar"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Sudah punya akun? Login",
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
