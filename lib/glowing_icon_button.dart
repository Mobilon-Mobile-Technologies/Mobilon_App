import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class GlowingIconButton extends StatefulWidget {
  final bool isOn;
  final SvgPicture iconOff;
  final SvgPicture iconOn;
  final VoidCallback onTap;
  final double size;
  

  const GlowingIconButton({super.key, required this.isOn, required this.onTap, required this.iconOff, required this.iconOn, this.size = 80,});

  @override
  GlowingIconButtonState createState() => GlowingIconButtonState();
}

class GlowingIconButtonState extends State<GlowingIconButton> {

  void onTap(){
    setState(() {
      widget.onTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.isOn) // Glow effect only when active
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              //borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff33BDFE).withAlpha(100),
                  offset: Offset(-2, -4),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),BoxShadow(
                  color: const Color(0xff692FFE).withAlpha(110),
                  offset: Offset(2, 4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        if (widget.isOn)
        ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                  begin: Alignment.topLeft,  // Start point at -8°
                  end: Alignment.bottomRight,  // End point at -8°
                  colors: [Color(0xff33BDFE),Color(0xff33BDFE),Color(0xff692FFE),Color(0xff692FFE)]
                  ).createShader(bounds);
              },
            child: Container(
              width: widget.size,
              height: widget.size,
    
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4)
              ),
              //color: Colors.white,
            )
        ),
        IconButton(
          icon: widget.isOn?widget.iconOn:widget.iconOff,
          onPressed: onTap ,
        ),
      ],
    );
  }
}