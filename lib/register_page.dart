import 'package:flutter/material.dart';
import 'package:fpresensi/auth_service.dart';
import 'package:fpresensi/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;

  Future<void> _register() async {
    String? result = await _authService.register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (result != null && result.isNotEmpty && result != 'null') {
      // Tampilkan pesan kesalahan jika registrasi gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    } else {
      // Jika berhasil, arahkan pengguna ke halaman login dan tampilkan pesan berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil membuat akun, silahkan login."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const Center(child: Text("REGISTER")),
                const SizedBox(height: 20),
                const Text("Email"),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'example@mail.com',
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
                    hintText: 'Harus 6 karakter atau lebih',
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
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: Text("Sudah punya akun? Login",
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
    );
  }
}
