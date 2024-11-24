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
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text('Tanggal: ${doc['date']}'),
                subtitle: Text('Lokasi: ${doc['location']}'),
                trailing: Text('Waktu: $formattedTime'),
              ),
            );
          },
        );
      },
    );
  }
}
