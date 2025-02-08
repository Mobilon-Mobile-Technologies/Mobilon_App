import 'dart:ui';

import 'package:flutter/material.dart';

class LargeAppBar extends StatelessWidget implements PreferredSizeWidget{
  const LargeAppBar({
    super.key,
    required this.screenHeight,
    required this.title,
    required this.titleStyle,
  });

  final double screenHeight;
  final String title;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      toolbarHeight: screenHeight*0.2,
      centerTitle: false,
      backgroundColor: Colors.black.withAlpha(80),
      title: 
      BackdropFilter(
        //Blur behind
        filter: ImageFilter.blur(sigmaX: 25,sigmaY: 25),
        child: Text(title,style: titleStyle,),
      ),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(screenHeight*0.12);
}