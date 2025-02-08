import 'package:admin_page/constants/style.dart';
import 'package:admin_page/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:admin_page/widgets/dashboardcard.dart';
import 'package:admin_page/widgets/eventcard.dart';


class DashboardPage extends StatefulWidget {
  final String userType;

  const DashboardPage({super.key, required this.userType});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<String> eventNames = ["Zennovate", "Parth", "FlutterFest"];




  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: LargeAppBar(
          screenHeight: screenHeight, title: "DashBoard", titleStyle: titleStyle.copyWith(fontSize: screenHeight*0.07)),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Text("My Events", style: bodyStyle),
              const SizedBox(height: 12),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (String i in eventNames)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: IntrinsicWidth(
                              child: EventCard(
                                  eventName: i,
                                  bodyStyle: bodyStyle.copyWith(
                                      fontSize: screenWidth*0.04),
                                  subStyle: subStyle,
                                  reserve: () => Navigator.pushNamed(
                                      context, '/Dashboard/qr'))),
                        ),
                    ],
                  )),
              const SizedBox(height: 24),
              Text("My Community", style: bodyStyle),
              const SizedBox(height: 12),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (String i in eventNames)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: IntrinsicWidth(
                              child: DashboardCard(
                            eventName: i,
                            bodyStyle:
                                bodyStyle.copyWith(fontSize: screenWidth*0.04),
                            subStyle: subStyle.copyWith(fontSize: screenWidth*0.03),
                          )),
                        ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
