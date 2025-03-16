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
      body: Container(
        decoration: BoxDecoration(
          //Background image
          image: DecorationImage(image: AssetImage("assets/Background.png"),fit: BoxFit.cover)
        ),
        child: Padding(
          padding: EdgeInsets.all(meanSize/40),
          child: ListView(

            scrollDirection: Axis.vertical,
            children: [
              Padding(
              padding: EdgeInsets.all(meanSize/20),
              child: GradientBox(
                child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                    width: meanSize/2,
                    height: meanSize/2,
                    decoration: BoxDecoration(
                      //Background image
                      image: DecorationImage(image: AssetImage("assets/qr.png"),fit: BoxFit.contain)
                    ),
                    ),

                    GradLine(),
                    Text(widget.event.name,style: bodyStyle,),
                    Text(widget.event.location,style: subStyle,),
                    Text(widget.event.start_date,style: subStyle,),
                    Text("UniqueID: $key", style: subStyle),
                    GradLine(),
                    Text(widget.event.description,style:bodyStyle.copyWith(color: Color(0xff808182)))
                  ]
                )
                ),
              )
            ]
          )
        )
      )
    );
  }
}