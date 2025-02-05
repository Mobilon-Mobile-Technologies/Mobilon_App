// ignore_for_file: avoid_print


//Admin Page Screen

import 'package:admin_page/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'border_button.dart';
import 'gradient_line.dart';
import 'gradient_box.dart';
import 'large_title_app_bar.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key, required this.title});
  final String title;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
 
 //Gradient taken from figma
  List<Color> radientGrad = [Color(0xFF9DE8EE),Color(0xFFFA7C0B),Color(0xFF9F8CED)];

  //Function to get icon from svg picture
  SvgPicture iconGet(String name){
    return SvgPicture.asset(
      'assets/Icons/$name.svg'
    );
  }

 

  @override
  Widget build(BuildContext context) {

    //Screen dimensions
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height; 
    


    //For sigular size elements
    double meanSize = (screenWidth+screenHeight)/2;

    TextStyle bodyStyle = TextStyle(color: Colors.white, fontFamily: "Aldrich",fontSize: meanSize/35);
    TextStyle titleStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: meanSize/15);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: LargeAppBar(screenHeight: screenHeight, title: widget.title, titleStyle: titleStyle),
      bottomNavigationBar: BottomBar(buttonIndex: 3,),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // SizedBox(
                  //   //Space for AppBar since it's transparent
                  //   height: screenHeight/6.5,
                  // ),
              
                  //Screen starts here...
              
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Admin Tools",style: bodyStyle,),
                  ),
                  GradientBox( 
                  height: screenHeight/3.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Events",style: bodyStyle,),
                          Row(
                            children: [
                              //TODO: Edit and Create Event Screens
                              BorderButton(onTap: () => print("Edit Event"), height: screenHeight/25,text: "Edit",),
                              BorderButton(onTap: () => print("Create Event"), height: screenHeight/25,text: "Create",)
                            ],
                          )
                        ],
                      ),
                      GradLine() ,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Other",style: bodyStyle,),
                          Row(
                            children: [
                              //TODO
                              BorderButton(onTap: () => print("Edit Other"), height: screenHeight/25,text: "Edit",),
                              BorderButton(onTap: () => print("Create Other"), height: screenHeight/25,text: "Create",)
                            ],
                          )
                        ],
                      ),
                      GradLine(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Other",style: bodyStyle,),
                          Row(
                            children: [
                              //TODO
                              BorderButton(onTap: () => print("Edit Other"), height: screenHeight/25,text: "Edit",),
                              BorderButton(onTap: () => print("Create Other"), height: screenHeight/25,text: "Create",)
                            ],
                          )
                        ],
                      ),
                      
                      
                    ],
                  )
                  ),
              
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Other Admin Stuff",style: bodyStyle,),
                  ),
                  GradientBox( 
                  height: screenHeight/3.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Stuff",style: bodyStyle,),
                          BorderButton(onTap: () => print("View Stuff"), height: screenHeight/25,text: "View",)
                        ],
                      ),
                      GradLine(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Other",style: bodyStyle,),
                          Row(
                            children: [
                              //TODO
                              BorderButton(onTap: () => print("Action 1"), height: screenHeight/25,text: "Action 1",),
                              BorderButton(onTap: () => print("Action 2"), height: screenHeight/25,text: "Action 2",)
                            ],
                          )
                        ],
                      ),
                      GradLine(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Other",style: bodyStyle,),
                          Row(
                            children: [
                              //TODO
                              BorderButton(onTap: () => print("Action 1"), height: screenHeight/25,text: "Action 1",),
                              BorderButton(onTap: () => print("Action 2"), height: screenHeight/25,text: "Action 2",)
                            ],
                          )
                        ],
                      ),
                      
                      
                    ],
                  )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



