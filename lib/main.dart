// ignore_for_file: depend_on_referenced_packages
import 'package:admin_page/dashboard.dart';
import 'package:admin_page/leaderboard_page.dart';
import 'package:admin_page/login.dart';
import 'package:admin_page/mainscreen.dart';
import 'package:admin_page/profile_page.dart';
import 'package:admin_page/qr_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'admin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Initialize Supabase with the environment variables
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const RSVPApp());
}

class RSVPApp extends StatelessWidget {
  const RSVPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AdminPage',
      initialRoute: '/Dashboard',
      routes: {
        '/Dashboard': (context) => DashboardPage(),
        '/': (context) => EventsPage(),
        '/admin': (context) => const AdminPage(title: "Admin"),
        '/Dashboard/qr': (context) => const QRPage(title: "QR Page"),
        '/leaderboard': (context) =>
            const LeaderboardPage(title: "Leaderboards"),
        '/profile': (context) => const ProfilePage(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
