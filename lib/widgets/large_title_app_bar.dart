
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
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      automaticallyImplyLeading: true,
      toolbarHeight: screenHeight*0.2,
      centerTitle: false,
      backgroundColor: Colors.black.withAlpha(80),
      title: 
      Padding(
        padding: const EdgeInsets.all(35),
        child: Text(title,style: titleStyle,),
      ),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(screenHeight*0.12);
}