import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:geolocator/geolocator.dart';

class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  // Fungsi untuk mendapatkan displayName
  static Future<String?> getDisplayName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (user.displayName != null) {
          return user.displayName;
        } else {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists && userDoc['displayName'] != null) {
            return userDoc['displayName'];
          } else {
            return "Nama Tidak Ditemukan";
          }
        }
      } else {
        return "User belum login";
      }
    } catch (e) {
      print("Error memuat displayName: $e");
      return "Error memuat nama";
    }
  }

  // Fungsi validasi biometrik
  static Future<bool> authenticateWithBiometrics() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _auth.authenticate(
        localizedReason: 'Gunakan biometrik untuk melanjutkan presensi',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (e) {
      print('Kesalahan autentikasi biometrik: $e');
    }
    return isAuthenticated;
  }

  // Fungsi untuk menyimpan presensi
  static Future<void> saveAttendance(Position position) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User tidak ditemukan. Harap login terlebih dahulu.');
      }

      // Referensi ke Firestore
      CollectionReference attendanceRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('attendance');

      DateTime now = DateTime.now();
      Timestamp timestamp = Timestamp.fromDate(now);

      Map<String, dynamic> attendanceData = {
        'date': DateFormat('yyyy-MM-dd').format(now),
        'time': timestamp,
        'location': 'Lat: ${position.latitude}, Lon: ${position.longitude}',
      };

      await attendanceRef.add(attendanceData);
      print('Presensi berhasil disimpan!');
    } catch (e) {
      print('Error menyimpan presensi: $e');
    }
  }
}
