// ignore_for_file: avoid_print


//QR Page Screen

import 'package:eventa/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/gradient_line.dart';
import '../widgets/gradient_box.dart';
import '../models/events.dart';
import '../functions/make_qr.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key, required this.event});
  final Events event;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {

 //Gradient taken from figma
  List<Color> radientGrad = [Color(0xFF9DE8EE),Color(0xFFFA7C0B),Color(0xFF9F8CED)];

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
      appBar: LargeAppBar(screenHeight: screenHeight, title: "Reserve: ${widget.event.name}", titleStyle: titleStyle),
      body: Container(
        decoration: BoxDecoration(
          //Background image
          image: DecorationImage(image: AssetImage("assets/Background.png"),fit: BoxFit.cover)
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(meanSize/40),
            child: ListView(
          
              scrollDirection: Axis.vertical,
              children: [
                GradientBox(
                  child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                      width: meanSize/2,
                      height: meanSize/2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: ShaderMask(
                              blendMode: BlendMode.srcATop,
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.black, Colors.deepPurple],
                                  tileMode: TileMode.clamp,
                                ).createShader(bounds);
                              },
                              child: genReserveQr(widget.event, meanSize/2),
                            ),
                          ),
                        ),
                      ),
                      ),
                
                      GradLine(),
                      Text(widget.event.name,style: bodyStyle,),
                      Text(widget.event.location,style: subStyle,),
                      Text("From ${widget.event.start_date} at ${widget.event.start_time.substring(0,5)}\nto ${widget.event.end_date} at ${widget.event.end_time.substring(0,5)}",style: subStyle,),
                      GradLine(),
                      Text(widget.event.description,style:bodyStyle.copyWith(color: Color(0xff808182)))
                    ]
                  )
                  )
              ]
            )
          ),
        )
      )
    );
  }
}