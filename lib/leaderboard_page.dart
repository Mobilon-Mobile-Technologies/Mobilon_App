// ignore_for_file: avoid_print


//QR Page Screen

import 'package:admin_page/border_button.dart';
import 'package:admin_page/gradient_box.dart';
import 'package:admin_page/gradient_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'glowing_icon_button.dart';
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

  List<bool> highlight = [true,false,false];
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
    

    void iconTap(int index){
      //make the specific index glow upon clicking the button
      setState(() {

        switch (index){
          case 0:
            Navigator.pushNamed(context,'/');
            break;
          case 1: 
            Navigator.pushNamed(context, '/Dashboard');
            break;
          case 2:
            Navigator.pushNamed(context,'/admin');
            break;

        }

        //TODO
        //index 0 - Home
        //index 1 - Events
        //index 2 - Profile
      });
      
    }


    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: LargeAppBar(screenHeight: screenHeight, title: widget.title, titleStyle: titleStyle),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.none,
        color: Color(0xff1D1F24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          GlowingIconButton(onTap: () => iconTap(0), iconOff: iconGet('HomeOff'),iconOn: iconGet('HomeOn'), isOn: highlight[0], size: meanSize/13),
          GlowingIconButton(onTap: () => iconTap(1), iconOff: iconGet('LibraryOff'),iconOn: iconGet('LibraryOn'), isOn: highlight[1], size: meanSize/13),
          GlowingIconButton(onTap: () => iconTap(2), iconOff: iconGet('UserOff'),iconOn: iconGet('UserOn'), isOn: highlight[2], size: meanSize/13),
        ],)
        ),
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