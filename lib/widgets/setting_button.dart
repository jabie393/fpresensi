import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String title;

  const SettingButton({
    required this.onPressed,
    required this.icon,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed, // Panggil fungsi onPressed
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[500],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(icon), // Ikon tombol
      label: Text(title), // Judul tombol
    );
  }
}
