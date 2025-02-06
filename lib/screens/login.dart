import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _loginWithMicrosoft(BuildContext context) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.azure,
        redirectTo: 'com.example.mobilon_app://login-callback/',
      );

      if (!response) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to login with Microsoft: ${response.toString()}')),
          );
        }
        return;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully logged in with Microsoft')),
        );

        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
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
              child: Image.asset("assets/images/img1.png"),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Login to your account',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/'),
              icon: const Icon(Icons.account_circle),
              label: const Text('Login with Microsoft'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}