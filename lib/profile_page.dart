import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Background.png"), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
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
                  color: Colors.white),
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
                  buildProfileField('Email', 'abcd123456@bennett.edu.in', true),
                  buildDivider(),
                  buildProfileField('Year', '1st', true),
                  buildDivider(),
                  buildProfileField('DOB', '01/01/2001', true),
                  buildDivider(),
                  buildProfileField('Admin panel', '', false),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 12),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Log Out',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            buildBottomNavBar(),
          ],
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
                  fontWeight: FontWeight.w500),
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
              onPressed: () {},
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

  Widget buildBottomNavBar() {
    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home, color: Colors.grey, size: 30),
          Icon(Icons.grid_view, color: Colors.grey, size: 30),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [
                Colors.blue.withOpacity(0.2),
                Colors.purple.withOpacity(0.2)
              ]),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}
