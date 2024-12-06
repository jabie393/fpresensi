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
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[500],
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Ikon dan teks di sebelah kiri
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(width: 10), // Spasi antara ikon dan teks
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
