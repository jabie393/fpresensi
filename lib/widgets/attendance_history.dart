import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AttendanceHistory extends StatelessWidget {
  const AttendanceHistory({super.key});

  @override
  Widget build(BuildContext context) {
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
            final timestamp = doc['time'] as Timestamp;
            final time = timestamp.toDate();
            final formattedTime = DateFormat('HH:mm').format(time);

            return Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(
                    8.0), // Memberikan padding di sekitar Card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tanggal di tengah atas
                    Center(
                      child: Text(
                        '${doc['date']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                        height: 5.0), // Jarak antara tanggal dan konten lainnya
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ikon kalender
                        const Icon(Icons.calendar_today, size: 30),
                        const SizedBox(
                            width: 12.0), // Jarak antara ikon dan detail lokasi
                        // Detail lokasi
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lokasi :',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Lat : ${doc['latitude']}'),
                              Text('Lon : ${doc['longitude']}'),
                            ],
                          ),
                        ),
                        // Waktu
                        Text(
                          'Waktu : $formattedTime',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
