import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inisialisasi notifikasi lokal
  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Mendapatkan token FCM
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Mengirim pesan notifikasi lokal
  Future<void> showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'presensi_channel', // ID channel
      'Presensi Notifications', // Nama channel
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  // Mendengarkan pesan FCM saat aplikasi aktif
  void listenForMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(
            message.notification?.title, message.notification?.body);
      }
    });
  }

  // Menangani notifikasi saat aplikasi dalam keadaan background
  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    print("Pesan diterima di background: ${message.notification?.title}");
  }
}
