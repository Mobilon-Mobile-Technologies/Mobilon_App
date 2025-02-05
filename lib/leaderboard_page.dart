// ignore_for_file: avoid_print


//QR Page Screen

import 'package:admin_page/border_button.dart';
import 'package:admin_page/bottom_app_bar.dart';
import 'package:admin_page/gradient_box.dart';
import 'package:admin_page/gradient_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'large_title_app_bar.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key, required this.title});
  final String title;

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
 
 //Gradient taken from figma
  List<Color> radientGrad = [Color(0xFF9DE8EE),Color(0xFFFA7C0B),Color(0xFF9F8CED)];

  //Function to get icon from svg picture
  SvgPicture iconGet(String name){
    return SvgPicture.asset(
      'assets/Icons/$name.svg'
    );
  }

  List<bool> highlight = [false,true,false,false];
  List<String> teamNames = ["Team A", "Team B", "Team C"];
  

  @override
  Widget build(BuildContext context) {

    //Screen dimensions
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height; 
    double meanSize = (screenWidth+screenHeight)/2;
    TextStyle bodyStyle = TextStyle(color: Colors.white, fontFamily: "Aldrich",fontSize: meanSize/35);
    TextStyle subStyle = TextStyle(color: Color(0xff808182), fontFamily: "Aldrich",fontSize: meanSize/50);
    TextStyle titleStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: meanSize/15);
    



    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: LargeAppBar(screenHeight: screenHeight, title: widget.title, titleStyle: titleStyle),
      bottomNavigationBar: BottomBar(buttonIndex: 1),
      body: Container(
        decoration: BoxDecoration(
          //Background image
          image: DecorationImage(image: AssetImage("assets/Background.png"),fit: BoxFit.cover)
        ),
        child: Padding(
          padding: EdgeInsets.all(meanSize/20),
          child: ListView(

            scrollDirection: Axis.vertical,
            children: [
              GradientBox(
                height: screenHeight/2,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  for (int i = 0 ; i < teamNames.length ; i++)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(children: [
                              Text(teamNames[i],style:bodyStyle),
                              leaderboardPos(i, subStyle),
                            ],),
                            BorderButton(text: "Details", onTap: () => print("View details")),
                          ],
                        ),
                        GradLine(),
                      ],
                    ),
                    
                ],)
                )
            ]
          )
        )
      )
    );
  }

  dynamic leaderboardPos(int i, TextStyle subStyle) {
    switch (i){
                    case 0: return Text("#${i+1}",style: subStyle.copyWith(color: Color(0xffFFFF00)));
                    case 1: return Text("#${i+1}",style: subStyle.copyWith(color: Color(0xffFF9900)));
                    case 2: return Text("#${i+1}",style: subStyle.copyWith(color: Color(0xff6AA1D7)));
                    default: return Text("#${i+1}",style: subStyle);
                  }
  }
}