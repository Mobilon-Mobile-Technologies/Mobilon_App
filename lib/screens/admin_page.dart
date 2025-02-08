// // ignore_for_file: avoid_print


// //Admin Page Screen

// import 'package:admin_page/screens/admin_screens/admin_dash.dart';
// import 'package:admin_page/screens/admin_screens/create_event.dart';
// import 'package:admin_page/screens/admin_screens/edit_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../widgets/border_button.dart';
// import '../widgets/gradient_line.dart';
// import '../widgets/gradient_box.dart';
// import '../widgets/glowing_icon_button.dart';
// import '../widgets/large_title_app_bar.dart';

// class AdminPage extends StatefulWidget {
//   const AdminPage({super.key, required this.title});
//   final String title;

//   @override
//   State<AdminPage> createState() => _AdminPageState();
// }

// class _AdminPageState extends State<AdminPage> {
 
//  //Gradient taken from figma
//   List<Color> radientGrad = [Color(0xFF9DE8EE),Color(0xFFFA7C0B),Color(0xFF9F8CED)];

//   //Function to get icon from svg picture
//   SvgPicture iconGet(String name){
//     return SvgPicture.asset(
//       'assets/Icons/$name.svg'
//     );
//   }

 

//   @override
//   Widget build(BuildContext context) {
//     List<bool> highlight = [false,false,true];

//     //Screen dimensions
//     double screenWidth = MediaQuery.sizeOf(context).width;
//     double screenHeight = MediaQuery.sizeOf(context).height; 
    

//     void iconTap(int index){
//       setState(() {
//         switch (index){
//           case 0:
//             Navigator.pushNamed(context,'/');
//             break;
//           case 1: 
//             Navigator.pushNamed(context, '/Dashboard');
//             break;
//           case 2:
//             Navigator.pushNamed(context,'/admin');
//             break;

//         }

//         //TODO
//         //index 0 - Home
//         //index 1 - Events
//         //index 2 - Profile
//       });
      
//     }

//     //For sigular size elements
//     double meanSize = (screenWidth+screenHeight)/2;

//     TextStyle bodyStyle = TextStyle(color: Colors.white, fontFamily: "Aldrich",fontSize: meanSize/35);
//     TextStyle titleStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: meanSize/15);
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       backgroundColor: Colors.black,
//       appBar: LargeAppBar(screenHeight: screenHeight, title: widget.title, titleStyle: titleStyle),
//       bottomNavigationBar: BottomAppBar(
//         clipBehavior: Clip.none,
//         color: Color(0xff1D1F24),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//           GlowingIconButton(onTap: () => iconTap(0), iconOff: iconGet('HomeOff'),iconOn: iconGet('HomeOn'), isOn: highlight[0], size: meanSize/13),
//           GlowingIconButton(onTap: () => iconTap(1), iconOff: iconGet('LibraryOff'),iconOn: iconGet('LibraryOn'), isOn: highlight[1], size: meanSize/13),
//           GlowingIconButton(onTap: () => iconTap(2), iconOff: iconGet('UserOff'),iconOn: iconGet('UserOn'), isOn: highlight[2], size: meanSize/13),
//         ],)
//         ),
//       body: Container(
//         decoration: BoxDecoration(
//           //Background image
//           image: DecorationImage(image: AssetImage("assets/Background.png"),fit: BoxFit.cover)
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(meanSize/40),
//           child: ListView(
//             scrollDirection: Axis.vertical,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   // SizedBox(
//                   //   //Space for AppBar since it's transparent
//                   //   height: screenHeight/6.5,
//                   // ),
              
//                   //Screen starts here...
              
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text("Admin Tools",style: bodyStyle,),
//                   ),
//                   GradientBox( 
//                   height: screenHeight/3.5,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Events",style: bodyStyle,),
//                           Row(
//                             children: [
//                               //TODO: Edit and Create Event Screens
//                               BorderButton(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) => AdminDash(userType: 'Admin',)),
//                                   );
//                                 },
//                                 height: screenHeight / 25,
//                                 text: "Edit",
//                               ),
//                               BorderButton(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) => CreateEventScreen()),
//                                   );
//                                 },
//                                 height: screenHeight / 25,
//                                 text: "Create",
//                               ),
                              
//                             ],
//                           )
//                         ],
//                       ),
//                       GradLine() ,
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Other",style: bodyStyle,),
//                           Row(
//                             children: [
//                               //TODO
//                               BorderButton(onTap: () => print("Edit Other"), height: screenHeight/25,text: "Edit",),
//                               BorderButton(onTap: () => print("Create Other"), height: screenHeight/25,text: "Create",)
//                             ],
//                           )
//                         ],
//                       ),
//                       GradLine(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Other",style: bodyStyle,),
//                           Row(
//                             children: [
//                               //TODO
//                               BorderButton(onTap: () => print("Edit Other"), height: screenHeight/25,text: "Edit",),
//                               BorderButton(onTap: () => print("Create Other"), height: screenHeight/25,text: "Create",)
//                             ],
//                           )
//                         ],
//                       ),
                      
                      
//                     ],
//                   )
//                   ),
              
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text("Other Admin Stuff",style: bodyStyle,),
//                   ),
//                   GradientBox( 
//                   height: screenHeight/3.5,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Stuff",style: bodyStyle,),
//                           BorderButton(onTap: () => print("View Stuff"), height: screenHeight/25,text: "View",)
//                         ],
//                       ),
//                       GradLine(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Other",style: bodyStyle,),
//                           Row(
//                             children: [
//                               //TODO
//                               BorderButton(onTap: () => print("Action 1"), height: screenHeight/25,text: "Action 1",),
//                               BorderButton(onTap: () => print("Action 2"), height: screenHeight/25,text: "Action 2",)
//                             ],
//                           )
//                         ],
//                       ),
//                       GradLine(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Other",style: bodyStyle,),
//                           Row(
//                             children: [
//                               //TODO
//                               BorderButton(onTap: () => print("Action 1"), height: screenHeight/25,text: "Action 1",),
//                               BorderButton(onTap: () => print("Action 2"), height: screenHeight/25,text: "Action 2",)
//                             ],
//                           )
//                         ],
//                       ),
                      
                      
//                     ],
//                   )
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

