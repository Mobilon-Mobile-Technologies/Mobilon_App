// import 'package:eventa/screens/eventa.dart';
// import 'package:eventa/widgets/dashboardcard.dart';
// import 'package:eventa/widgets/glowing_icon_button.dart';
// import 'package:eventa/widgets/large_title_app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.dark(),
//       home: const AdminProfile(),
//     );
//   }
// }

// class AdminProfile extends StatefulWidget {
//   const AdminProfile({super.key});

//   @override
//   _AdminProfileState createState() => _AdminProfileState();
// }

// class _AdminProfileState extends State<AdminProfile> {
//   List<bool> highlight = [false, false, true];
//   double meanSize = 0;
//   double screenHeight = 0;
//   TextStyle titleStyle = const TextStyle(
//       color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);
//   List<String> eventNames = ["Event 1", "Event 2", "Event 3"];

//   void iconTap(int index) {
//     setState(() {
//       switch (index) {
//         case 0:
//           Navigator.pushNamed(context, '/');
//           break;
//         case 1:
//           Navigator.pushNamed(context, '/Dashboard');
//           break;
//         case 2:
//           Navigator.pushNamed(context, '/profile');
//           break;
//       }
//     });
//   }

//   SvgPicture iconGet(String name) {
//     return SvgPicture.asset('assets/Icons/$name.svg');
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     meanSize = (screenWidth + screenHeight) / 2;

//     return Scaffold(
//       appBar: LargeAppBar(
//           screenHeight: screenHeight, title: "Profile", titleStyle: titleStyle),
//       extendBodyBehindAppBar: true,
//       extendBody: true,
      
//       body: SingleChildScrollView(
//         child: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(
//                   "assets/Background.png"), // Ensure the path is correct
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(
//                   height: 100), // Adjusted to avoid overlap with app bar
//               const CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.person, size: 60, color: Colors.black),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Full Name',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Column(
//                   children: [
//                     buildProfileField('Enrollment Number', 'ABCD1234', true),
//                     buildDivider(),
//                     buildProfileField(
//                         'Email', 'abcd123456@bennett.edu.in', true),
//                     buildDivider(),
//                     buildProfileField('Year', '1st', true),
//                     buildDivider(),
//                     buildProfileField('DOB', '01/01/2001', true),
//                     buildDivider(),
//                     buildProfileField('Admin panel', '', false),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                   height:
//                       30), // Adjusted to avoid overlap with bottom navigation bar
//               TextButton(
//                 style: TextButton.styleFrom(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
//                   backgroundColor:
//                       Colors.blue.withOpacity(0.5), // Gradient background
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 onPressed: () {},
//                 child: const Text(
//                   'Log Out',
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         clipBehavior: Clip.none,
//         color: const Color(0xff1D1F24),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             GlowingIconButton(
//                 onTap: () => iconTap(0),
//                 iconOff: iconGet('HomeOff'),
//                 iconOn: iconGet('HomeOn'),
//                 isOn: highlight[0],
//                 size: meanSize / 13),
//             GlowingIconButton(
//                 onTap: () => iconTap(1),
//                 iconOff: iconGet('LibraryOff'),
//                 iconOn: iconGet('LibraryOn'),
//                 isOn: highlight[1],
//                 size: meanSize / 13),
//             GlowingIconButton(
//                 onTap: () => iconTap(2),
//                 iconOff: iconGet('UserOff'),
//                 iconOn: iconGet('UserOn'),
//                 isOn: highlight[2],
//                 size: meanSize / 13),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildProfileField(String title, String value, bool editable) {
//     return ListTile(
//       title: Text(
//         title,
//         style: const TextStyle(color: Colors.grey, fontSize: 14),
//       ),
//       subtitle: value.isNotEmpty
//           ? Text(
//               value,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             )
//           : null,
//       trailing: editable
//           ? TextButton(
//               style: TextButton.styleFrom(
//                 backgroundColor: Colors.white.withOpacity(0.2),
//               ),
//               onPressed: () {},
//               child:
//                   const Text('Edit', style: TextStyle(color: Colors.white70)),
//             )
//           : ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => AdminPage(title: "Admin")));
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.white.withOpacity(0.2),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//               ),
//               child: const Text('Open', style: TextStyle(color: Colors.white)),
//             ),
//     );
//   }

//   Widget buildDivider() {
//     return const Divider(color: Colors.grey, thickness: 0.5);
//   }

//   Widget buildBottomNavBar() {
//     return Container(
//       color: Colors.black,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Icon(Icons.home, color: Colors.grey, size: 30),
//           Icon(Icons.grid_view, color: Colors.grey, size: 30),
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.blue.withOpacity(0.2),
//                   Colors.purple.withOpacity(0.2),
//                 ],
//               ),
//             ),
//             child: const Icon(Icons.person, color: Colors.white, size: 30),
//           ),
//         ],
//       ),
//     );
//   }
// }
