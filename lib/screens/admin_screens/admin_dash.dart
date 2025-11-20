import 'package:eventa/functions/get_events.dart';
import 'package:eventa/models/events.dart';
import 'package:eventa/widgets/admin/admindashcard.dart';
import 'package:eventa/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:eventa/functions/reserve.dart';

import 'package:flutter_svg/flutter_svg.dart';

class AdminDash extends StatefulWidget {
  final String userType;
  const AdminDash({super.key, required this.userType});

  @override
  State<AdminDash> createState() => _AdminDashState();
}

class _AdminDashState extends State<AdminDash> {
  final List<bool> highlight = [true, false, false];
  List<Events> events = [];
  List<String> reservedEvents = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentOffset = 0;
  final ScrollController _scrollController = ScrollController();

  SvgPicture iconGet(String name) {
    return SvgPicture.asset('assets/Icons/$name.svg');
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

  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final thresholdReached = _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.95;

    if (thresholdReached) {
      _loadMoreEvents();
    }
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
      currentOffset = fetchedEvents.length;
      hasMore = fetchedEvents.length == 100;
      isLoading = false;
    });
  }

  Future<void> _loadMoreEvents() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    final fetchedEvents = await getEvents(currentOffset, 100);

    setState(() {
      events.addAll(fetchedEvents);
      currentOffset += fetchedEvents.length;
      hasMore = fetchedEvents.length == 100;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double meanSize = (screenWidth + screenHeight) / 2;

    TextStyle bodyStyle = TextStyle(
        color: Colors.white, fontFamily: "Aldrich", fontSize: meanSize / 35);
    TextStyle subStyle = TextStyle(
        color: Color(0xff808182),
        fontFamily: "Aldrich",
        fontSize: meanSize / 50);
    TextStyle titleStyle = TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: meanSize / 15);

    return Scaffold(
      appBar: LargeAppBar(
          screenHeight: screenHeight, title: "Events", titleStyle: titleStyle),
      extendBodyBehindAppBar: false,
      extendBody: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/create_event');
          },
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: Colors.white, width: 2),
          ),
          label: Text(
            "Create Event",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/Background.png"),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: EdgeInsets.all(meanSize / 40),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/qr_scanner');
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan QR Codes'),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: events.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == events.length) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }

                    final event = events[index];
                    return Padding(
                      padding: EdgeInsets.all(6),
                      child: Admindashcard(
                        event: event,
                        bodyStyle: bodyStyle,
                        subStyle: subStyle,
                        edit: () {
                          Navigator.pushNamed(
                            context,
                            '/edit_event',
                            arguments: event,
                          );
                        },
                        reserve: () async {
                          reserveEvent(event.events_id);
                          await getReservedEvents();
                          setState(() => _loadEvents());
                        },
                        showQr: () => Navigator.pushNamed(
                          context, '/Dashboard/qr', arguments: event
                      ),
                      )
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
