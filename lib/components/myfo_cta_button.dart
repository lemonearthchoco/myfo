import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfo/components/myfo_text.dart';

class MyfoCtaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  MyfoCtaButton({ required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: MyfoText(label, color: Colors.white),
        ),
      ),
    );
  }
}