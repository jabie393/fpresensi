import 'package:permission_handler/permission_handler.dart';

// Fungsi untuk memeriksa dan meminta izin lokasi
Future<bool> checkLocationPermission() async {
  // Memeriksa apakah izin lokasi di latar depan sudah diberikan
  PermissionStatus locationPermission = await Permission.location.status;

  // Memeriksa apakah izin lokasi di latar belakang diperlukan
  PermissionStatus backgroundPermission =
      await Permission.locationAlways.status;

  if (locationPermission.isGranted && backgroundPermission.isGranted) {
    return true; // Izin sudah diberikan untuk lokasi dan latar belakang
  } else {
    // Meminta izin lokasi jika belum diberikan
    PermissionStatus locationStatus = await Permission.location.request();

    // Meminta izin lokasi di latar belakang jika belum diberikan
    PermissionStatus backgroundStatus =
        await Permission.locationAlways.request();

    return locationStatus.isGranted && backgroundStatus.isGranted;
  }
}
