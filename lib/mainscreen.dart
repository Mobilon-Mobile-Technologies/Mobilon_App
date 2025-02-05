import 'package:admin_page/dashboardcard.dart';
import 'package:admin_page/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'glowing_icon_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  final List<bool> highlight = [true,false,false];

  SvgPicture iconGet(String name){
    return SvgPicture.asset(
      'assets/Icons/$name.svg'
    );
  }

  final List<String> eventNames = [
    "Zennovate",
    "Parth",
    'abc',
  ];

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height; 
    double meanSize = (screenWidth+screenHeight)/2;

    void iconTap(int index){
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
    }
    );
    }

    TextStyle bodyStyle = TextStyle(color: Colors.white, fontFamily: "Aldrich",fontSize: meanSize/35);
    TextStyle subStyle = TextStyle(color: Color(0xff808182), fontFamily: "Aldrich",fontSize: meanSize/50);
    TextStyle titleStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: meanSize/15);

    return Scaffold(
      appBar: LargeAppBar(screenHeight: screenHeight, title: "Events", titleStyle: titleStyle),
      extendBodyBehindAppBar: true,
      extendBody: true,
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
            image: DecorationImage(
          image: AssetImage("assets/Background.png"),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: EdgeInsets.all(meanSize/40),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              for (String i in eventNames)
              Padding(
                padding: EdgeInsets.all(6),
                child: DashboardCard(eventName: i, bodyStyle: bodyStyle, subStyle: subStyle,),
                )
                  
            ],
          ),
        ),
      ),
    );
  }
}
