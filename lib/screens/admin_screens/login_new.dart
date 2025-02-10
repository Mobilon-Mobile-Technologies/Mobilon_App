import 'package:admin_page/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<bool> isSelected = [true, false];
  String userType = "Student";

  Future<void> _loginWithMicrosoft(BuildContext context) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.azure,
        authScreenLaunchMode: LaunchMode.inAppWebView,
        redirectTo: "https://bdnzbelpbjqtohgkbmkc.supabase.co/auth/v1/callback",
      );

      if (!response) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to login with Microsoft')),
          );
        }
        return;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully logged in with Microsoft')),
        );

        Navigator.pushReplacementNamed(context, '/Dashboard');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    // final emailRegex =
    //     RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+@bennett\.edu\.in$');
    // if (!emailRegex.hasMatch(value)) {
    //   return 'Only @bennett.edu.in emails are allowed';
    // }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Image.asset("assets/FlutterImg.png"),
                ),
                const SizedBox(height: 20),
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushReplacementNamed(context, '/Dashboard');
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // ElevatedButton.icon(
                //   onPressed: () => _loginWithMicrosoft(context),
                //   icon: const Icon(Icons.account_circle),
                //   label: const Text('Login with Microsoft'),
                //   style: ElevatedButton.styleFrom(
                //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
