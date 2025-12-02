import 'package:eventa/constants/style.dart';
import 'package:eventa/models/events.dart';
import 'package:eventa/screens/team_registeration.dart';
import 'package:eventa/widgets/eventcard.dart';
import 'package:eventa/widgets/gradient_line.dart';
import 'package:eventa/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eventa/functions/reserve.dart';
import 'package:eventa/functions/get_events.dart';

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
  bool isLoading = false;
  bool atLimit = false;
  int offset = 0;
  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreEvents();
    }
  }

  Future<void> _loadMoreEvents() async {
    if (isLoading || !atLimit) return;

    setState(() {
      isLoading = true;
    });

    final fetchedEvents = await getEvents(offset, 100);
    
    setState(() {
      events.addAll(fetchedEvents);
      offset += fetchedEvents.length;
      atLimit = fetchedEvents.length == 100;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    if (isLoading) return;
    
    setState(() {
      isLoading = true;
    });

    final fetchedEvents = await getEvents(0, 100);
    final fetchedReserved = await getReservedEvents();
    
    setState(() {
      events = fetchedEvents;
      reservedEvents = fetchedReserved;
      offset = fetchedEvents.length;
      atLimit = fetchedEvents.length == 5;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: LargeAppBar(
        screenHeight: screenHeight, 
        title: "Events", 
        titleStyle: titleStyle.copyWith(fontSize: 45)
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Background.png"),
              fit: BoxFit.cover,
            )
          ),
          child: Padding(
            padding: EdgeInsets.all(screenHeight*0.001),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: events.length + 1,
              itemBuilder: (context, index) {
                if (index == events.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: atLimit 
                        ? const CircularProgressIndicator()
                        : GradLine()
                    ),
                  );
                }
        
                final event = events[index];
                if (!(reservedEvents.contains(event.events_id))) {
                  return EventCard(
                    event: event,
                    bodyStyle: bodyStyle,
                    subStyle: subStyle.copyWith(fontSize: screenHeight*0.015),
                    reserve: () async {
                      // Check if team event
                      if (event.team_size > 1) {
                        // Navigate to team registration screen
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamRegistrationScreen(event: event),
                          ),
                        );
                        
                        // Refresh if registration was successful
                        if (result == true) {
                          setState(() => _loadEvents());
                        }
                      } else {
                        // Single reservation
                        reserveEvent(event.events_id);
                        await getReservedEvents();
                        setState(() => _loadEvents());
                      }
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}