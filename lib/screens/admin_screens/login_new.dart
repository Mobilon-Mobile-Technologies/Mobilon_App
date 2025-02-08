import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPageNew extends StatefulWidget {
  const LoginPageNew({super.key});
  //final sched;

  @override
  _LoginPageNewState createState() => _LoginPageNewState();
}

class _LoginPageNewState extends State<LoginPageNew> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to sign in the user
  Future<void> _signIn(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // Sign in using Supabase
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // If sign-in is successful, navigate to HomePage
      if (response.user != null) {
        Navigator.pop(context);
      } else {
        // Show error if no user is returned
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in')),
        );
      }
    } catch (error) {
      // Catch any errors and show the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.asset(
                    "assets/images/img1.png",
                    height: 200,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Sign In",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email TextField
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5, vertical: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _signIn(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text("Sign In"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
