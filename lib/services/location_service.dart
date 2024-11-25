import 'package:geolocator/geolocator.dart';

class LocationService {
  // Fungsi untuk mendapatkan lokasi saat ini
  static Future<Position> getCurrentLocation() async {
    // Periksa apakah layanan lokasi diaktifkan
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Bawa pengguna ke pengaturan lokasi
      await Geolocator.openLocationSettings();
    }

    // Periksa izin lokasi
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Izin lokasi ditolak secara permanen. Silakan periksa izin di pengaturan.');
      } else if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak');
      }
    }

    // Dapatkan posisi saat ini
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Fungsi untuk memeriksa apakah posisi berada di area kantor
  static bool isInOfficeArea(Position position) {
    const double officeLatitude = -8.168549;
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
}
