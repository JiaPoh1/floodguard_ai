import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.buttonText, required this.callback});

  final String buttonText;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(1000, 50),
        backgroundColor: Color(0xFF0D47A1),
        foregroundColor: Colors.white,
      ),
      child: Text(buttonText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}
