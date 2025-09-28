import 'package:admin_page/functions/reserve.dart';
import 'package:admin_page/screens/admin_screens/admin_dash.dart';
import 'package:admin_page/widgets/gradient_box.dart';
import 'package:admin_page/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/isLoggedInAsAdmin.dart' as AdminStatus; // Add this import

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

  @override
  void initState() {
    super.initState();
    _loadAdminStatus();
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                      buildProfileField('Enrollment Number', 'ABCD1234', true),
                      buildDivider(),
                      buildProfileField(
                          'Email', supabase.auth.currentUser?.email ?? 'Email not found', false),
                      buildDivider(),
                      buildProfileField('Year', '1st', true),
                      buildDivider(),
                      buildProfileField('DOB', '01/01/2001', true),
                      buildDivider(),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
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
                const SizedBox(height: 30),
              ],
            ),
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
          : null,
    );
  }

  Widget buildDivider() {
    return const Divider(color: Colors.grey, thickness: 0.5);
  }
}
