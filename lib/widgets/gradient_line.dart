import 'package:flutter/material.dart';

class GradLine extends StatelessWidget {
  const GradLine({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        width: double.infinity,
        height: 1,
        child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(2), // Needed for ShaderMask
          ),
          ),
        ),
    );
  }
}