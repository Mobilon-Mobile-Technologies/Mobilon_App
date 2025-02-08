import 'package:admin_page/screens/admin_screens/admin_dash.dart';
import 'package:admin_page/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatefulWidget {
  final String userType;
  const ProfilePage({super.key, required this.userType});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<bool> highlight = [false, false, true];
  double meanSize = 0;
  double screenHeight = 0;
  TextStyle titleStyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);
  List<String> eventNames = ["Event 1", "Event 2", "Event 3"];

  void iconTap(int index) {
    setState(() {
      switch (index) {
        case 0:
          if (widget.userType == "Admin") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AdminDash(userType: "Admin")),
            );
          } else {
            Navigator.pushNamed(context, '/');
          }

          break;
        case 1:
          Navigator.pushNamed(context, '/Dashboard');

          break;
        case 2:
          Navigator.pushNamed(context, '/profile');
          break;
      }
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

    return Scaffold(
      appBar: LargeAppBar(
          screenHeight: screenHeight, title: "Profile", titleStyle: titleStyle),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/Background.png"), // Ensure the path is correct
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                  height: 100), // Adjusted to avoid overlap with app bar
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 60, color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text(
                'Full Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    buildProfileField('Enrollment Number', 'ABCD1234', true),
                    buildDivider(),
                    buildProfileField(
                        'Email', 'abcd123456@bennett.edu.in', true),
                    buildDivider(),
                    buildProfileField('Year', '1st', true),
                    buildDivider(),
                    buildProfileField('DOB', '01/01/2001', true),
                    buildDivider(),
                  ],
                ),
              ),
              const SizedBox(
                  height:
                      30), // Adjusted to avoid overlap with bottom navigation bar
              TextButton(
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  backgroundColor: const Color.fromARGB(255, 247, 38, 23)
                      .withOpacity(0.5), // Gradient background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      
    );
  }

  Widget buildProfileField(String title, String value, bool editable) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      subtitle: value.isNotEmpty
          ? Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
      trailing: editable
          ? TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
              ),
              onPressed: () {},
              child:
                  const Text('Edit', style: TextStyle(color: Colors.white70)),
            )
          : ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminDash(userType: "Admin")));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Open', style: TextStyle(color: Colors.white)),
            ),
    );
  }

  Widget buildDivider() {
    return const Divider(color: Colors.grey, thickness: 0.5);
  }

  
}
