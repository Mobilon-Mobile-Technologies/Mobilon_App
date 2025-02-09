import 'package:admin_page/constants/style.dart';
import 'package:admin_page/models/events.dart';
import 'package:admin_page/widgets/dashboardcard.dart';
import 'package:admin_page/widgets/large_title_app_bar.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsPage extends StatefulWidget {
  final String userType;

  const EventsPage({super.key, required this.userType});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final supabase = Supabase.instance.client;
  List<Events> events = [];

  int _count = 10;
  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    getEvents();
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return EasyRefresh(
      controller: _controller,
      header: BezierHeader(),
      onRefresh: () async {
        await getEvents();
        _controller.finishRefresh();
        _controller.resetFooter();
      },
      onLoad: () async {
        await getEvents();
        _controller.finishLoad(
            _count >= 20 ? IndicatorResult.noMore : IndicatorResult.success);
      },
      child: Scaffold(
        appBar: LargeAppBar(
            screenHeight: screenHeight,
            title: "Events",
            titleStyle: titleStyle.copyWith(fontSize: screenHeight * 0.07)),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/Background.png"),
            fit: BoxFit.cover,
          )),
          child: Padding(
            padding: EdgeInsets.all(screenHeight * 0.001),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                for (Events event in events)
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: DashboardCard(
                      event: event,
                    ),
                  )
              ],
            ),
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
              ))
          .toList();
    });
  }
}
