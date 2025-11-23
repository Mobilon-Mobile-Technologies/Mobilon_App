
import 'package:eventa/functions/reserve.dart';
import 'package:eventa/screens/admin_screens/admin_dash.dart';
import 'package:eventa/widgets/gradient_box.dart';
import 'package:eventa/widgets/gradient_line.dart';
import 'package:eventa/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/is_logged_in_as_admin.dart' as AdminStatus; // Add this import

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
  String email = "Email not found";
  String enrolment = "";
  String year = "";
  TextStyle titleStyle = const TextStyle(
  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 45);

  @override
  void initState() {
    super.initState();
    _loadAdminStatus();
    _getProfileValues();
  }

  Future<void> _getProfileValues() async {
    email = supabase.auth.currentUser?.email ?? 'Email not found';
    enrolment = email.split("@")[0].toUpperCase();
    int n = enrolment.length;
    for (int i=0; i<n; i++) {
      if (int.tryParse(enrolment[i])!=null) {
        int evalYear = DateTime(2000 + int.parse(enrolment[i] + enrolment[i+1])).year;
        int curYear = DateTime.now().year;
        year = (curYear - evalYear + 1).toString();
      }
    }
  }
  
  // Load admin status when page loads
  Future<void> _loadAdminStatus() async {
    await AdminStatus.setAdminStatus();
    setState(() {}); // Refresh UI after admin status is loaded
  }

  void iconTap(int index) {
    setState(() {
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AdminDash(userType: "Admin")),
          );
          // if (widget.userType == "Admin") {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => AdminDash(userType: "Admin")),
          //   );
          // } else {
          //   Navigator.pushNamed(context, '/');
          // }

          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/Dashboard');

          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/profile');
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
      extendBodyBehindAppBar: false,
      extendBody: true,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/Background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 60, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    supabase.auth.currentUser!.userMetadata?['full_name'] ?? 'User Name',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GradientBox(
                    child: Column(
                      children: [
                        buildProfileField('Enrollment Number', enrolment),
                        GradLine(),
                        buildProfileField(
                            'Email', email),
                        GradLine(),
                        buildProfileField('Year', year),
                        GradLine(),
                        buildProfileField("User Type", widget.userType)
                        // buildProfileField('DOB', '01/01/2001'),
                        // buildDivider(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  
                  // Admin-only button for Mark Entry
                  if (AdminStatus.is_admin) // Only show if user is admin
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                        label: const Text(
                          'Mark Event Entry',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          backgroundColor: Colors.blue.withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/qr_scanner');
                        },
                      ),
                    ),
                  
                  TextButton(
                    style: TextButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 247, 38, 23)
                          .withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      supabase.auth.signOut(); 
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                    child: const Text(
                      'Log Out',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileField(String title, String value) {
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
    );
  }

  Widget buildDivider() {
    return const Divider(color: Colors.grey, thickness: 0.5);
  }
}
