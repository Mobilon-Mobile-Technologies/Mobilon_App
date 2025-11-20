import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _loginWithMicrosoft(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.azure,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
        authScreenLaunchMode: LaunchMode.externalApplication,
        scopes: 'openid email profile User.Read'
      );
      
      print('OAuth flow initiated...');
      
    } catch (e) {
      print('Login error: $e');
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset("assets/Eventa_transparent.png")),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Login to your account',
                    style: TextStyle(fontFamily: 'Aldrich', color: Colors.white, fontSize: 20),
                  ),
                ),
                // Form(
                //   key: _formKey,
                //   child: Column(
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.symmetric(vertical: 8.0),
                //         child: TextFormField(
                //           controller: _emailController,
                //           decoration: const InputDecoration(
                //             labelText: 'Email',
                //             border: OutlineInputBorder(),
                //           ),
                //           validator: _validateEmail,
                //           keyboardType: TextInputType.emailAddress,
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(vertical: 8.0),
                //         child: TextFormField(
                //           controller: _passwordController,
                //           decoration: const InputDecoration(
                //             labelText: 'Password',
                //             border: OutlineInputBorder(),
                //           ),
                //           obscureText: true,
                //         ),
                //       ),
                //       const SizedBox(height: 20),
                //       ElevatedButton(
                //         onPressed: _loginWithEmailAndPassword,
                //         child: const Text('Login'),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _loginWithMicrosoft(context),
                  icon: const Icon(Icons.account_circle),
                  label: const Text('Login with College Email', style: TextStyle(fontFamily: 'Aldrich', fontSize: 12),),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
