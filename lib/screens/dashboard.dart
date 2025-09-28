import 'package:admin_page/constants/style.dart';
import 'package:admin_page/models/events.dart';
import 'package:admin_page/widgets/border_button.dart';
import 'package:admin_page/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:admin_page/widgets/dashboardcard.dart';
import 'package:admin_page/functions/get_events.dart';


class DashboardPage extends StatefulWidget {
  final String userType;

  const DashboardPage({super.key, required this.userType});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;


    return Scaffold(
      appBar: LargeAppBar(
          screenHeight: screenHeight, title: "DashBoard", titleStyle: titleStyle.copyWith(fontSize: screenHeight*0.07)),
      extendBodyBehindAppBar: false,
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BorderButton(text: "Scan Reservation QR", onTap: () => Navigator.pushNamed(context, '/reserve_qr')),
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Text("Reserved Events", style: bodyStyle),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (Events i in events)
                              if (reservedEvents.contains(i.events_id) && DateTime.parse("${i.end_date}T${i.end_time}").isAfter(DateTime.now()))
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: IntrinsicWidth(
                                  child: DashboardCard(
                                  event: i,
                                  navigatorToReserveQR: () => Navigator.pushReplacementNamed(context, '/event_details', arguments: i),
                                  navigatorToQR: () => Navigator.pushNamed(context, '/Dashboard/qr', arguments: i),
                                  bodyStyle:
                                      bodyStyle.copyWith(fontSize: screenWidth*0.04),
                                  subStyle: subStyle.copyWith(fontSize: screenWidth*0.03),
                                )),
                              ),
                          ],
                        )),
                    const SizedBox(height: 24),
                    Text("My Events", style: bodyStyle),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (Events i in events)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: IntrinsicWidth(
                                    child: DashboardCard(
                                  event: i,
                                  navigatorToReserveQR: () => Navigator.pushNamed(context, '/event_details', arguments: i),
                                  navigatorToQR: () => Navigator.pushNamed(context, '/Dashboard/qr', arguments: i),
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
            ],
          ),
        ),
      ),
    );
  }
}
