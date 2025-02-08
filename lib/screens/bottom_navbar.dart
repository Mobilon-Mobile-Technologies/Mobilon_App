import 'package:admin_page/screens/eventsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dashboard.dart';
import 'profile_page.dart';
import 'admin_screens/admin_dash.dart';
import 'package:admin_page/widgets/glowing_icon_button.dart';

class BottomNavigationPage extends StatefulWidget {
  final String userType;

  const BottomNavigationPage({super.key, required this.userType});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _selectedIndex = 0;
  List<bool> highlight = [false, false, true];
  double meanSize = 0;
  double screenHeight = 0;
  TextStyle titleStyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);
  List<String> eventNames = ["Event 1", "Event 2", "Event 3"];

  void iconTap(int index) {
    setState(() {
      _selectedIndex = index;
      highlight = [false, false, false];
      highlight[index] = true;
    });
  }

  SvgPicture iconGet(String name) {
    return SvgPicture.asset('assets/Icons/$name.svg');
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    meanSize = (screenWidth + screenHeight) / 2;

    List<Widget> _pages = [
      widget.userType == "Admin" ? AdminDash(userType: widget.userType) : EventsPage(userType: widget.userType),
      DashboardPage(userType: widget.userType),
      ProfilePage(userType: widget.userType),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.none,
        color: const Color(0xff1D1F24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GlowingIconButton(
                onTap: () => iconTap(0),
                iconOff: iconGet('HomeOff'),
                iconOn: iconGet('HomeOn'),
                isOn: highlight[0],
                size: meanSize / 13),
            GlowingIconButton(
                onTap: () => iconTap(1),
                iconOff: iconGet('LibraryOff'),
                iconOn: iconGet('LibraryOn'),
                isOn: highlight[1],
                size: meanSize / 13),
            GlowingIconButton(
                onTap: () => iconTap(2),
                iconOff: iconGet('UserOff'),
                iconOn: iconGet('UserOn'),
                isOn: highlight[2],
                size: meanSize / 13),
          ],
        ),
      ),
    );
  }
}