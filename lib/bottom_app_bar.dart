import 'package:admin_page/glowing_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    required this.buttonIndex,
    this.meanSize = 550,
  });

  final int buttonIndex;
  final double meanSize;
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

    SvgPicture iconGet(String name){
    return SvgPicture.asset(
      'assets/Icons/$name.svg'
    );
  }

 static List<bool> highlight = [false,false,false,false];

  void iconTap(int index){
    setState(() {
      switch (index){
        case 0:

          Navigator.pushNamed(context,'/');
          break;
        case 1: 

          Navigator.pushNamed(context, '/leaderboard');
          break;
        case 2:

          Navigator.pushNamed(context,'/dashboard');
          break;
        case 3:

          Navigator.pushNamed(context,'/admin');
          break;
      }

      //TODO
      //index 0 - Home
      //index 1 - Events
      //index 2 - Profile
    });
    
  }

  @override
  Widget build(BuildContext context) {
    highlight = [false,false,false,false];
    highlight[widget.buttonIndex] = true;

    
    return BottomAppBar(
      clipBehavior: Clip.none,
      color: Color(0xff1D1F24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
        GlowingIconButton(onTap: () => iconTap(0), iconOff: iconGet('HomeOff'),iconOn: iconGet('HomeOn'), isOn: highlight[0], size: widget.meanSize/13),
        GlowingIconButton(onTap: () => iconTap(1), iconOff: iconGet('LeaderboardOff'),iconOn: iconGet('LeaderboardOn'), isOn: highlight[1], size: widget.meanSize/13),
        GlowingIconButton(onTap: () => iconTap(2), iconOff: iconGet('LibraryOff'),iconOn: iconGet('LibraryOn'), isOn: highlight[2], size: widget.meanSize/13),
        GlowingIconButton(onTap: () => iconTap(3), iconOff: iconGet('UserOff'),iconOn: iconGet('UserOn'), isOn: highlight[3], size: widget.meanSize/13),
      ],)
      );
  }
}