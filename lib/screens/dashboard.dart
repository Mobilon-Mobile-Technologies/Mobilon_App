import 'package:eventa/constants/style.dart';
import 'package:eventa/models/events.dart';
import 'package:eventa/widgets/border_button.dart';
import 'package:eventa/widgets/gradient_box.dart';
import 'package:eventa/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:eventa/widgets/dashboardcard.dart';
import 'package:eventa/functions/get_events.dart';


class DashboardPage extends StatefulWidget {
  final String userType;

  const DashboardPage({super.key, required this.userType});

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> with RouteAware {
  List<Events> events = [];
  List<String> reservedEvents = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentOffset = 0;
  final ScrollController _scrollController = ScrollController();
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();


  @override
  void initState() {
    super.initState();
    _loadEvents();
    _scrollController.addListener(_scrollListener);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    // Called when returning to this screen from another screen
    print('Returned to Dashboard - refreshing data');
    _loadEvents();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // For horizontal scroll in Reserved Events
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
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
      hasMore = fetchedEvents.length == 5;
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


    return Scaffold(
      appBar: LargeAppBar(
          screenHeight: screenHeight, title: "DashBoard", titleStyle: titleStyle.copyWith(fontSize: 45)),
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
                child: BorderButton(
                  text: "Scan Reservation QR", 
                  onTap: () => Navigator.pushNamed(context, '/reserve_qr')
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Text("Reserved Events", style: bodyStyle),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...events.where((i) => 
                            reservedEvents.contains(i.events_id)
                          ).map((i) => 
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0),
                              child: IntrinsicWidth(
                                child: DashboardCard(
                                  event: i,
                                  navigatorToReserveQR: () => Navigator.pushNamed(
                                    context, '/event_details', arguments: i
                                  ),
                                  navigatorToQR: () => Navigator.pushNamed(
                                    context, '/Dashboard/qr', arguments: i
                                  ),
                                  bodyStyle: bodyStyle.copyWith(fontSize: screenWidth*0.04),
                                  subStyle: subStyle.copyWith(fontSize: screenWidth*0.03),
                                )
                              ),
                            )
                          ),
                          if (hasMore)
                            Padding(
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
                            ),
                        ],
                      )
                    ),
                    const SizedBox(height: 24),
                    Text("My Events", style: bodyStyle),
                    const SizedBox(height: 12),
                    GradientBox(child: Text("Coming soon!"))
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
