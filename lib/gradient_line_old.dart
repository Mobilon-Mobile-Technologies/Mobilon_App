import 'package:flutter/material.dart';

class GradLine extends StatelessWidget {
  const GradLine({
    super.key,
    required this.radientGrad,
  });

  final List<Color> radientGrad;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
                      return LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: radientGrad,
                      ).createShader(bounds);
                      },
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: 2,
        child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2), // Needed for ShaderMask
          ),
          ),
        ),
    ),
    );
  }
}