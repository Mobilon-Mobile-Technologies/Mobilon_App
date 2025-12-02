import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onTap, required this.text, this.icon, this.ratio=0.08});
  final VoidCallback onTap;
  final String text;
  final Image? icon;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.blue, spreadRadius: -1, blurRadius: 19),
        ],
      ),
      child: ElevatedButton(
        onPressed: onTap,

        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
          minimumSize: MaterialStateProperty.all(
            Size(size.width, size.height * ratio),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(width: 8),
            if (icon != null) ...[SizedBox(
                width: 24.0, 
                height: 24.0, 
                child: icon,
              ),],
          ],
        ),
      ),
    );
  }
}