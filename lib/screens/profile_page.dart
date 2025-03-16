import 'package:admin_page/constants/style.dart';
import 'package:admin_page/screens/admin_screens/admin_dash.dart';
import 'package:admin_page/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  final String userType;
  const ProfilePage({super.key, required this.userType});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;
  List<bool> highlight = [false, false, true];

  // User profile data
  String? enrollmentNumber;
  String? username;
  String? dob;
  String? email;

  // Loading state
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch user profile data when the page loads
    _fetchUserProfile();
  }

  // Function to fetch user profile data from the database
  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user email
      final userEmail = supabase.auth.currentUser?.email;

      if (userEmail != null) {
        // Query the profile table to get user data
        final data = await supabase
            .from('profile')
            .select()
            .eq('Email', userEmail)
            .single();

        // Update state with the fetched data
        setState(() {
          username = data['UserName'];
          enrollmentNumber = data['EnrollNo'];
          dob = data['DOB'];
          email = data['Email'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      // Handle any errors
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error fetching profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: LargeAppBar(
            screenHeight: screenHeight,
            title: "Profile",
            titleStyle: titleStyle.copyWith(fontSize: screenHeight * 0.05)),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Background.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Skeletonizer(
              enabled: _isLoading,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                      height: 100), // Adjusted to avoid overlap with app bar
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white70,
                    child: Icon(Icons.person, size: 60, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    username ?? "User",
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
                        buildProfileField(
                            'Enrollment Number', enrollmentNumber ?? 'Not set', true),
                        buildDivider(),
                        buildProfileField('Email', email ?? supabase.auth.currentUser?.email ?? 'Not set', true),
                        buildDivider(),
                        buildProfileField('DOB', dob ?? 'Not set', true),
                        buildDivider(),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height:
                          30), // Adjusted to avoid overlap with bottom navigation bar
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 247, 38, 23)
                          .withOpacity(0.5), // Gradient background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      supabase.auth.signOut();
                      Navigator.popAndPushNamed(context, '/login');
                    },
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
