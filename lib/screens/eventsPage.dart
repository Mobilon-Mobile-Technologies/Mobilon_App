import 'package:admin_page/constants/style.dart';
import 'package:admin_page/models/events.dart';
import 'package:admin_page/widgets/eventcard.dart';
import 'package:admin_page/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:admin_page/functions/reserve.dart';
import 'package:admin_page/functions/get_events.dart';

class EventsPage extends StatefulWidget {
  final String userType;

  const EventsPage({super.key, required this.userType});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final supabase = Supabase.instance.client;
  List<Events> events = [];
  List<String> reservedEvents = [];


  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final fetchedEvents = await getEvents();
    final fetchedReserved = await getReservedEvents();
    setState(() {
      events = fetchedEvents;
      reservedEvents = fetchedReserved;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: LargeAppBar(
        screenHeight: screenHeight, 
        title: "Events", 
        titleStyle: titleStyle.copyWith(fontSize: screenHeight*0.07)
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Background.png"),
            fit: BoxFit.cover,
          )
        ),
        child: Padding(
          padding: EdgeInsets.all(screenHeight*0.001),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              
              for (var i in events)
              if (!(reservedEvents.contains(i.events_id))) EventCard(event: i, bodyStyle: bodyStyle, subStyle: subStyle.copyWith(fontSize: screenHeight*0.015), reserve: () async {
              reserveEvent(i.events_id);
              await getReservedEvents();
              setState(() => _loadEvents());
            },)
            ]
          ),
        ),
      ),
    );
  }
}