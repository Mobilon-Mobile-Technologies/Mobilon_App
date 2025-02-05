import 'package:admin_page/bottom_app_bar.dart';
import 'package:admin_page/dashboardcard.dart';
import 'package:admin_page/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  final List<bool> highlight = [true,false,false,false];

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


    TextStyle bodyStyle = TextStyle(color: Colors.white, fontFamily: "Aldrich",fontSize: meanSize/35);
    TextStyle subStyle = TextStyle(color: Color(0xff808182), fontFamily: "Aldrich",fontSize: meanSize/50);
    TextStyle titleStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: meanSize/15);

    return Scaffold(
      appBar: LargeAppBar(screenHeight: screenHeight, title: "Events", titleStyle: titleStyle),
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: BottomBar(buttonIndex: 0),
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
