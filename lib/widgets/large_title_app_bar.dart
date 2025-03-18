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
      automaticallyImplyLeading: false,
      toolbarHeight: screenHeight*0.2,
      centerTitle: false,
      backgroundColor: Colors.black.withAlpha(100),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
      title: Row(
        children: [
          if (Navigator.of(context).canPop())
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: titleStyle,
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(screenHeight*0.12);
}