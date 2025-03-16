import 'package:admin_page/constants/style.dart';
import 'package:admin_page/models/events.dart';
import 'package:admin_page/widgets/large_title_app_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:admin_page/widgets/dashboardcard.dart';
import 'package:admin_page/widgets/eventcard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPage extends StatefulWidget {
  final String userType;

  const DashboardPage({super.key, required this.userType});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Events> registeredEvents = [];
  List<Events> communityEvents = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadEvents();

  }

  Future<void> _loadEvents() async {
    setState(() => isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user != null) {
        // Get user's ID from profile
        final profileData = await supabase
            .from('profile')
            .select('user_id')
            .eq('Email', user.email.toString())
            .single();

        final userId = profileData['user_id'];

        // Get registered events from dashboard
        final registeredData = await supabase
            .from('dashboard')
            .select('event_id')
            .eq('user_id', userId);

        final eventIds =
            registeredData.map((record) => record['event_id']).toList();

        // Fetch full event details for registered events
        if (eventIds.isNotEmpty) {
          final eventsData = await supabase
              .from('events')
              .select()
              .filter('event_id', 'in', eventIds);

          registeredEvents = eventsData
              .map((event) => Events(
                    event['event_id'] as int, // Convert to int for events_id
                    event['name'] ?? '',
                    event['start_date']?.toString() ?? '',
                    event['start_time']?.toString() ?? '',
                    event['end_date']?.toString() ?? '',
                    event['end_time']?.toString() ?? '',
                    event['location'] ?? '',
                    event['description'] ?? '',
                    event['capacity']?.toString() ?? '',
                  ))
              .toList();
        }

        // // Fetch community events (you can modify this based on your requirements)
        // final communityData =
        //     await supabase.from('events').select().eq('type', 'community');

        // if (communityData.isNotEmpty) {
        //   communityEvents = communityData
        //       .map((event) => Events(
        //             event['events_id'],
        //             event['name'],
        //             event['start_date'],
        //             event['start_time'],
        //             event['end_date'],
        //             event['end_time'],
        //             event['location'],
        //             event['description'],
        //             event['capacity'],
        //           ))
        //       .toList();
        // }
      }
    } catch (error) {
      debugPrint('Error loading events: $error');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load events. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
        appBar: LargeAppBar(
            screenHeight: screenHeight,
            title: "DashBoard",
            titleStyle: titleStyle.copyWith(fontSize: screenHeight * 0.07)),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Text("My Events", style: bodyStyle),
                        const SizedBox(height: 12),
                        if (registeredEvents.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                "No registered events yet",
                                style: subStyle.copyWith(color: Colors.grey),
                              ),
                            ),
                          )
                        else
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: registeredEvents
                                  .map((event) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0),
                                        child: IntrinsicWidth(
                                          child: EventCard(
                                            event: event,
                                            bodyStyle: bodyStyle.copyWith(
                                                fontSize: screenWidth * 0.04),
                                            subStyle: subStyle,
                                            reserve: () => Navigator.pushNamed(
                                                context, '/Dashboard/qr'),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        const SizedBox(height: 24),

                        // Only show community section if there are community events
                        if (communityEvents.isNotEmpty) ...[
                          Text("My Community", style: bodyStyle),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: communityEvents
                                  .map((event) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0),
                                        child: IntrinsicWidth(
                                          child: DashboardCard(event: event),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        );
  }
}
