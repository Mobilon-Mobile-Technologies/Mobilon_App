import 'dart:ui';

import 'package:flutter/material.dart';

class ButtonedAppBar extends StatelessWidget implements PreferredSizeWidget{
  const ButtonedAppBar({
    super.key,
    required this.screenHeight,
    this.prevTitle = "Back",
    this.nextTitle = "Go",
    this.leadOnward = false,
    this.searchHint = "Search",
    required this.title,
    required this.titleStyle,
    required this.onTap
  });

  final double screenHeight;
  final VoidCallback onTap;
  final bool leadOnward;
  final String prevTitle;
  final String nextTitle;
  final String title;
  final String searchHint;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: screenHeight/7,
      centerTitle: false,
      titleSpacing: 0,
      backgroundColor: Colors.black.withAlpha(80),
      title: 
      Padding(
        padding: const EdgeInsets.all(12),
        child: BackdropFilter(
          //Blur behind
          filter: ImageFilter.blur(sigmaX: 25,sigmaY: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: screenWidth/4.3,
                child: GestureDetector(
                  onTap: onTap,
                  child: Text("< $prevTitle",style:titleStyle.copyWith(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.normal), textAlign: TextAlign.start,))),
              SizedBox(
                width: screenWidth/2.3,
                child: Text(title,style: titleStyle,textAlign: TextAlign.center,)),
              SizedBox(
                width: screenWidth/4.3,
                child: Offstage(
                  offstage: !leadOnward,
                  child: Text(nextTitle,style: titleStyle.copyWith(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.normal), textAlign: TextAlign.end,)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(screenHeight/7);
}