import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final double borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    required this.color,
    this.textColor = Colors.white,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
    this.borderRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}