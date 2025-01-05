import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final VoidCallback? onSuffixIconPressed;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onSuffixIconPressed,
    super.key,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Icon(widget.icon),
        suffixIcon: widget.onSuffixIconPressed != null
            ? IconButton(
                icon: Icon(widget.obscureText
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: widget.onSuffixIconPressed,
              )
            : null,
        filled: true,
        fillColor: isDarkMode ? theme.cardColor : Colors.grey[200],
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[600]! : Colors.grey[400]!,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: _focusNode.hasFocus
                ? Colors.blue[400]!
                : Colors.blue[
                    400]!, // Mengubah warna outline menjadi biru saat fokus
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      keyboardType: widget.keyboardType,
    );
  }
}
