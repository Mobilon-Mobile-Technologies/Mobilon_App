// ignore_for_file: avoid_print


//

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'glowing_icon_button.dart';
import 'large_title_app_bar.dart';

class EmptyPage extends StatefulWidget {
  const EmptyPage({super.key, required this.title});
  final String title;

  @override
  State<EmptyPage> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
 
 //Gradient taken from figma
  List<Color> radientGrad = [Color(0xFF9DE8EE),Color(0xFFFA7C0B),Color(0xFF9F8CED)];

  //Function to get icon from svg picture
  SvgPicture iconGet(String name){
    return SvgPicture.asset(
      'assets/Icons/$name.svg'
    );
  }

  List<bool> highlight = [false,true,false];

  @override
  Widget build(BuildContext context) {

    //Screen dimensions
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height; 
    

    void iconTap(int index){
      //make the specific index glow upon clicking the button
      List<bool> iconVar = [false,false,false];
      iconVar[index] = !iconVar[index];
      setState(() {
        highlight = iconVar;

        switch (index){
          case 0:
            Navigator.popUntil(context,ModalRoute.withName('/'));
            Navigator.pushNamed(context,'/leaderboard');
            break;
          case 1: 
            Navigator.popUntil(context,ModalRoute.withName('/'));
            Navigator.pushNamed(context, '/Dashboard/qr');
            break;
          case 2:
            Navigator.popUntil(context,ModalRoute.withName('/'));
            Navigator.pushNamed(context,'/profile');
            break;

        }

        //TODO
        //index 0 - Home
        //index 1 - Events
        //index 2 - Profile
      });
      
    }


    //For sigular size elements
    double meanSize = (screenWidth+screenHeight)/2;

    TextStyle titleStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: meanSize/15);
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
          padding: EdgeInsets.all(meanSize/40),
          child: ListView(

            scrollDirection: Axis.vertical,
            children: [
              
            ]
          )
        )
      )
    );
  }
}