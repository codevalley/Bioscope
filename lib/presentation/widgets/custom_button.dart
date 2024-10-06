import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  static ButtonStyle get outlinedStyle => TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.black),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(double.infinity, 48),
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      minimumSize: const Size(double.infinity, 48),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    return TextButton(
      onPressed: onPressed,
      style: style ?? defaultStyle,
      child: child,
    );
  }
}
