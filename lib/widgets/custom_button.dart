import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.color = Colors.redAccent,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
        textStyle: TextStyle(fontSize: 18.0),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
