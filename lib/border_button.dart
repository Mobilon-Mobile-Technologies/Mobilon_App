import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  const BorderButton({
    super.key,
    required this.text,
 
    required this.onTap,
    this.height = 31
  });


  final String text;
  final double height;
  final VoidCallback onTap;
  

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    TextStyle bodyStyle = TextStyle(color: Colors.white, fontSize: (screenWidth+screenHeight)/80,fontFamily: "Inter");
    return Padding(
      padding: const EdgeInsets.all(1),
      child: SizedBox(
        height: height,
        child: ElevatedButton(onPressed: onTap, 
                              style: ButtonStyle(
                                side: WidgetStateProperty.all(
                                  BorderSide(color: Color(0xff424242),
                                  width: 1),),
                                backgroundColor: WidgetStateProperty.all<Color>(Color(0xff333333).withAlpha(70))),
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(begin: Alignment.topCenter,end:Alignment.bottomCenter,colors: [Colors.white, Colors.white, Colors.white.withAlpha(0)]).createShader(bounds),
                                child: Text(text,style: bodyStyle,)))),
    );
  }
}