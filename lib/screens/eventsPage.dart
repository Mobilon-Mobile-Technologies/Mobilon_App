import 'package:admin_page/constants/style.dart';
import 'package:admin_page/models/events.dart';
import 'package:admin_page/widgets/dashboardcard.dart';
import 'package:admin_page/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/glowing_icon_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventsPage extends StatefulWidget {
  final String userType;

  const EventsPage({super.key, required this.userType});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final supabase = Supabase.instance.client;
  List<Events> events = [];


  final List<String> eventNames = [
    "Zennovate",
    "Parth",
    'abc',
  ];

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: LargeAppBar(
          screenHeight: screenHeight, title: "Events", titleStyle: titleStyle.copyWith(fontSize: screenHeight*0.07)),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/Background.png"),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: EdgeInsets.all(screenHeight*0.001),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              for (Events event in events)
                Padding(
                  padding: EdgeInsets.all(6),
                  child: DashboardCard(
                    eventName: event.name,
                    bodyStyle: bodyStyle.copyWith(fontSize: screenWidth * 0.04),
                    subStyle: subStyle.copyWith(fontSize: screenWidth * 0.03),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getEvents() async {
  final list = await supabase.from("events").select("*");
  setState(() {
    events = list
      .map((event) => Events(
        event["event_id"].toString(),
        event["name"].toString(),
        event["start_date"],
        event["start_time"],
        event["end_date"],
        event["end_time"],
        event["location"],
        event["description"],
        event["capacity"].toString(), // Convert capacity to String
      )).toList();
  });
}

}