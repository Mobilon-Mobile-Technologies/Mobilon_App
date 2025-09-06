import 'package:admin_page/constants/style.dart';
import 'package:admin_page/models/events.dart';
import 'package:admin_page/widgets/dashboardcard.dart';
import 'package:admin_page/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:admin_page/functions/reserve.dart';

class EventsPage extends StatefulWidget {
  final String userType;

  const EventsPage({super.key, required this.userType});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final supabase = Supabase.instance.client;
  List<Events> events = [];


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
            children: events.map((event) {
              return FutureBuilder<bool>(
                future: checkIfReserved(event.events_id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  
                  final isReserved = snapshot.data ?? false;
                  if (isReserved) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: EdgeInsets.all(6),
                    child: DashboardCard(
                      event_id: event.events_id,
                      eventName: event.name,
                      bodyStyle: bodyStyle.copyWith(fontSize: screenWidth * 0.04),
                      subStyle: subStyle.copyWith(fontSize: screenWidth * 0.03),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  Future<void> getEvents() async {
  try {
    final list = await supabase
        .from('events')
        .select('*');
    
    print('Fetched data: $list'); // Debug print
    
    if (list.isNotEmpty) {
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
                  event["capacity"].toString(),
                ))
            .toList();
      });
      print('Parsed events: $events'); // Debug print
    } else {
      print('No events found in database');
    }
  } catch (error) {
    print('Error fetching events: $error');
  }
  }
}