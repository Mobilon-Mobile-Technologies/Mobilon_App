import 'package:admin_page/bottom_app_bar.dart';
import 'package:admin_page/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:admin_page/dashboardcard.dart';
import 'package:admin_page/eventcard.dart';
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

    


    //For sigular size elements
    double meanSize = (screenWidth+screenHeight)/2;

    TextStyle bodyStyle = TextStyle(color: Colors.white, fontFamily: "Aldrich",fontSize: meanSize/35);
    TextStyle subStyle = TextStyle(color: Color(0xff808182), fontFamily: "Aldrich",fontSize: meanSize/50);
    TextStyle titleStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: meanSize/15);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: LargeAppBar(screenHeight: screenHeight, title: "Dashboard", titleStyle: titleStyle),
      bottomNavigationBar: BottomBar(buttonIndex: 2),
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
                        child: IntrinsicWidth(child: EventCard(eventName: i,bodyStyle: bodyStyle.copyWith(fontSize: meanSize/44),subStyle: subStyle, reserve: () => Navigator.pushNamed(context, '/dashboard/qr')
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
