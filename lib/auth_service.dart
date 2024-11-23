import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi Login
  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential
          .user?.uid; // Mengembalikan UID pengguna jika berhasil
    } catch (e) {
      return null; // Mengembalikan null jika login gagal
    }
  }

  // Fungsi Registrasi
  Future<String?> register(
      String email, String password, String displayName) async {
    try {
      // Buat pengguna baru dengan email dan password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ambil UID dari pengguna yang baru terdaftar
      String uid = userCredential.user?.uid ?? "";

      // Update nama pengguna ke Firestore
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'displayName': displayName,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // Registrasi berhasil
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Email ini sudah terdaftar. Gunakan email lain atau login.';
      } else if (e.code == 'invalid-email') {
        return 'Format email tidak valid. Harap masukkan email yang benar.';
      } else if (e.code == 'weak-password') {
        return 'Kata sandi terlalu lemah. Gunakan minimal 6 karakter.';
      } else {
        return 'Harap isi Password & Email!';
      }
    } catch (e) {
      return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
