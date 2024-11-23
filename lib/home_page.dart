import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fpresensi/setting_page.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? displayName;

  @override
  void initState() {
    super.initState();
    _loadDisplayName();
  }

  final LocalAuthentication _auth = LocalAuthentication();

  // Fungsi untuk memuat displayName
  Future<void> _loadDisplayName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Cek apakah displayName tersedia di FirebaseAuth
        if (user.displayName != null) {
          setState(() {
            displayName = user.displayName;
          });
        } else {
          // Jika tidak ada, ambil dari Firestore
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists && userDoc['displayName'] != null) {
            setState(() {
              displayName = userDoc['displayName'];
            });
          } else {
            setState(() {
              displayName = "Nama Tidak Ditemukan";
            });
          }
        }
      } else {
        setState(() {
          displayName = "User belum login";
        });
      }
    } catch (e) {
      print("Error memuat displayName: $e");
      setState(() {
        displayName = "Error memuat nama";
      });
    }
  }

  // Pemeriksaan layanan lokasi sebelum mencoba mengambil lokasi
  Future<void> _checkAndEnableLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Jika layanan lokasi tidak aktif, tampilkan dialog kepada pengguna
      bool? userResponse = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Layanan Lokasi Tidak Aktif'),
            content: const Text(
                'Layanan lokasi diperlukan untuk melanjutkan. Apakah Kamu ingin mengaktifkannya?'),
            actions: [
              TextButton(
                child: const Text('Tidak'),
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // Kembali tanpa mengaktifkan
                },
              ),
              TextButton(
                child: const Text('Aktifkan'),
                onPressed: () async {
                  Navigator.of(context).pop(true); // Kembali untuk mengaktifkan
                },
              ),
            ],
          );
        },
      );

      if (userResponse == true) {
        // Buka pengaturan untuk mengaktifkan lokasi
        const AndroidIntent intent = AndroidIntent(
          action: 'android.settings.LOCATION_SOURCE_SETTINGS',
        );
        await intent.launch();
      }
    }
  }

  // Fungsi validasi biometrik
  Future<bool> _authenticateWithBiometrics() async {
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

  // Fungsi mendapatkan lokasi
  Future<Position> _getCurrentLocation() async {
    await _checkAndEnableLocation();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi tidak aktif');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Izin lokasi ditolak secara permanen');
      } else if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Fungsi untuk validasi lokasi
  bool _isInOfficeArea(Position position) {
    const double officeLatitude = -8.168549; // Ganti dengan koordinat kantor
    const double officeLongitude = 112.617868;
    const double maxDistance = 100; // Dalam meter

    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      officeLatitude,
      officeLongitude,
    );

    return distance <= maxDistance;
  }

  // Logika presensi
  Future<void> _handleAttendance() async {
    try {
      // Validasi biometrik
      bool isAuthenticated = await _authenticateWithBiometrics();
      if (!isAuthenticated) {
        _showMessage('Autentikasi biometrik gagal');
        return;
      }

      // Validasi lokasi
      Position position = await _getCurrentLocation();
      if (!_isInOfficeArea(position)) {
        _showMessage('Kamu berada di luar area lokasi kantor');
        return;
      }

      // Simpan presensi ke Firebase
      await saveAttendance(position);

      // Tampilkan notifikasi berhasil
      _showMessage('Presensi berhasil disimpan!');
    } catch (e) {
      _showMessage('Terjadi kesalahan: $e', isError: true);
    }
  }

  Future<void> saveAttendance(Position position) async {
    try {
      // Dapatkan user ID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User tidak ditemukan. Harap login terlebih dahulu.');
      }

      // Referensi ke Firestore
      CollectionReference attendanceRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Dokumen sesuai user ID
          .collection('attendance'); // Sub-collection presensi

      // Ambil waktu sekarang sebagai Timestamp
      DateTime now = DateTime.now();
      Timestamp timestamp = Timestamp.fromDate(now); // Waktu sebagai Timestamp

      // Data presensi
      Map<String, dynamic> attendanceData = {
        'date':
            DateFormat('yyyy-MM-dd').format(now), // Format Tanggal (yyyy-MM-dd)
        'time': timestamp, // Waktu sebagai Timestamp
        'location':
            'Lat: ${position.latitude}, Lon: ${position.longitude}', // Lokasi
      };

      // Simpan ke Firestore
      await attendanceRef.add(attendanceData);
      print('Presensi berhasil disimpan!');
    } catch (e) {
      print('Error menyimpan presensi: $e');
    }
  }

  // Fungsi untuk menampilkan pesan
  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error : Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.blue[500],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(
          title: Row(
            children: [
              // Tambahkan logo
              Image.asset(
                'assets/images/splash.png',
                height: 35, // Sesuaikan ukuran tinggi logo
              ),
              const SizedBox(width: 10), // Spasi antara logo dan teks
              Text(
                'F Presensi',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[500],
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[300],
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menampilkan displayName
                Text(
                  displayName != null
                      ? "Hai $displayName!"
                      : "Memuat nama pengguna...",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),
                const Text(
                  "Riwayat Presensi :",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Riwayat Presensi (buildAttendanceHistory)
                Expanded(
                  child: buildAttendanceHistory(),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _handleAttendance,
          backgroundColor: Colors.grey[50],
          child: const Icon(
            Icons.fingerprint,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

Widget buildAttendanceHistory() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return const Center(child: Text('Kamu belum login.'));
  }

  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('attendance')
        .orderBy('date', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('Belum ada riwayat presensi.'));
      }

      final attendanceDocs = snapshot.data!.docs;

      return ListView.builder(
        itemCount: attendanceDocs.length,
        itemBuilder: (context, index) {
          final doc = attendanceDocs[index];
          final timestamp = doc['time'] as Timestamp; // Waktu sebagai Timestamp
          final time = timestamp.toDate(); // Ubah ke DateTime
          final formattedTime =
              DateFormat('HH:mm').format(time); // Format ke HH:mm

          return Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('Tanggal: ${doc['date']}'),
              subtitle: Text('Lokasi: ${doc['location']}'),
              trailing:
                  Text('Waktu: $formattedTime'), // Tampilkan waktu terformat
            ),
          );
        },
      );
    },
  );
}
