import 'package:admin_page/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<bool> isSelected = [true, false];
  String userType = "Student";

  Future<void> _loginWithMicrosoft(BuildContext context) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.azure,
        redirectTo: 'com.example.mobilon_app://login-callback/',
      );

      if (!response) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Failed to login with Microsoft: ${response.toString()}')),
          );
        }
        return;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully logged in with Microsoft')),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => DashboardPage(userType:userType),
          ),
        );
      }

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Image.asset("assets/FlutterImg.png"),
            ),
            SizedBox(
              height: 20,
            ),
            ToggleButtons(
              borderRadius: BorderRadius.circular(10),
              children: const [
                Padding(padding: EdgeInsets.all(8.0), child: Text("Student")),
                Padding(padding: EdgeInsets.all(8.0), child: Text("Admin")),
              ],
              isSelected: isSelected,
              onPressed: (index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = (i == index);
                  }
                  userType = (index == 0) ? "Student" : "Admin";
                });
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Login to your account',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DashboardPage(userType: userType),
              ),
            ),
              icon: const Icon(Icons.account_circle),
              label: const Text('Login with Microsoft'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
