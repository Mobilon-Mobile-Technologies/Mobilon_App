import 'package:flutter/material.dart';

class GradientBox extends StatelessWidget {
  const GradientBox({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    required this.child
  });

  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Stack(
        alignment: Alignment.center,
        children: [Container(
        padding: EdgeInsets.all(8), // Border thickness
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white12, width: 1), // Needed for ShaderMask
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