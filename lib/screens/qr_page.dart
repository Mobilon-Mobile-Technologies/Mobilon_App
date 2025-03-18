// ignore_for_file: avoid_print


//QR Page Screen

import 'package:admin_page/models/events.dart';
import 'package:admin_page/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/gradient_line.dart';
import '../widgets/gradient_box.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QRPage extends StatefulWidget {
  const QRPage({super.key, required this.event});
  final Events event;

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  List<Color> radientGrad = [Color(0xFF9DE8EE), Color(0xFFFA7C0B), Color(0xFF9F8CED)];
  String? key;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('dashboard')
        .select('key')
        .eq('event_id', widget.event.events_id)
        .single();

    if (response.isNotEmpty) {
      setState(() {
        key = response['key'];
      });
    } else {
      print('Error fetching dashboard data: $response');
    }
  }

  //Function to get icon from svg picture
  SvgPicture iconGet(String name){
    return SvgPicture.asset(
      'assets/Icons/$name.svg'
    );
  }

  List<bool> highlight = [false,true,false];

  @override
  Widget build(BuildContext context) {
    //Screen dimensions
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height; 
    



    //For sigular size elements
    double meanSize = (screenWidth+screenHeight)/2;

    TextStyle bodyStyle = TextStyle(color: Colors.white, fontFamily: "Aldrich",fontSize: meanSize/35);
    TextStyle subStyle = TextStyle(color: Color(0xff808182), fontFamily: "Aldrich",fontSize: meanSize/50);
    TextStyle titleStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: meanSize/25);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: LargeAppBar(screenHeight: screenHeight, title: widget.event.name, titleStyle: titleStyle),
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/Background.png"), fit: BoxFit.cover)
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.fromLTRB(meanSize/40, screenHeight * 0.08, meanSize/40, meanSize/40),
              child: GradientBox(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // QR Code
                      AspectRatio(
                        aspectRatio: 1.0,
                        child: Container(
                          width: screenWidth * 0.6,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            image: DecorationImage(
                              image: AssetImage("assets/qr.png"),
                              fit: BoxFit.contain
                            )
                          ),
                        ),
                      ),

                      GradLine(),
                      
                      // Event details
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: Text(
                          widget.event.name, 
                          style: bodyStyle.copyWith(
                            fontSize: meanSize/32, 
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          widget.event.location, 
                          style: subStyle,
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          widget.event.start_date, 
                          style: subStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "UniqueID: ${key ?? 'Loading...'}",
                          style: subStyle.copyWith(
                            fontWeight: FontWeight.bold, 
                            fontSize: meanSize/45
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      GradLine(),
                      
                      // Description
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Text(
                          widget.event.description,
                          style: bodyStyle.copyWith(color: Color(0xff808182)),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}