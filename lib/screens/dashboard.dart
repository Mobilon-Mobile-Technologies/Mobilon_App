import 'package:admin_page/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:admin_page/widgets/dashboardcard.dart';
import 'package:admin_page/widgets/eventcard.dart';
import '../widgets/glowing_icon_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<String> eventNames = ["Zennovate", "Parth", "FlutterFest"];

    SvgPicture iconGet(String name){
    return SvgPicture.asset(
      'assets/Icons/$name.svg'
    );
  }

  @override
  Widget build(BuildContext context) {

    
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height; 

    List<bool> highlight = [false,true,false];
    
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

    TextStyle bodyStyle = TextStyle(color: Colors.white, fontFamily: "Aldrich",fontSize: meanSize/35);
    TextStyle subStyle = TextStyle(color: Color(0xff808182), fontFamily: "Aldrich",fontSize: meanSize/50);
    TextStyle titleStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: meanSize/15);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: LargeAppBar(screenHeight: screenHeight, title: "Dashboard", titleStyle: titleStyle),
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
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(meanSize/40),
          child: ListView(
            scrollDirection: Axis.vertical,  
              children: [
                // My Events Section
                Text(
                  "My Events",
                  style: bodyStyle,
                ),
                const SizedBox(height: 12),
          
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  
                  child: Row(children: [
                    for (String i in eventNames)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0,),
                        child: IntrinsicWidth(child: EventCard(eventName: i,bodyStyle: bodyStyle.copyWith(fontSize: meanSize/44),subStyle: subStyle, reserve: () => Navigator.pushNamed(context, '/Dashboard/qr')
                        )),
                      ),
                  ],)
                ),
                    
                const SizedBox(height: 24),
                    
                // My Community Section
                Text(
                  "My Community",
                  style: bodyStyle
                ),
                const SizedBox(height: 12),
                    
                // ✅ Fix overflow by ensuring proper height
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  
                  child: Row(children: [
                    for (String i in eventNames)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0,),
                        child: IntrinsicWidth(child: DashboardCard(eventName: i,bodyStyle: bodyStyle.copyWith(fontSize: meanSize/44),subStyle: subStyle,)),
                      ),
                  ],)
                )
              ],
            ),
        ),
        ),
      );
  }
}
