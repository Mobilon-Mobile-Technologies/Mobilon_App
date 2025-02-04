import 'package:flutter/material.dart';

class GradientBox extends StatelessWidget {
  const GradientBox({
    super.key,
    required this.radientGrad,
    this.width = double.infinity,
    this.height = 100,
    required this.child
  });

  final List<Color> radientGrad;
  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [ShaderMask(
        //padding: const EdgeInsets.all(4), // Space for the border
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: radientGrad,
            ).createShader(bounds);
        },
        child: Container(
        padding: EdgeInsets.all(8), // Border thickness
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 2), // Needed for ShaderMask
          ),
          ),
        ),
        Padding(
        padding: EdgeInsets.all(20),
        child: child
        ),
        ]
      ),
    );
  }
}