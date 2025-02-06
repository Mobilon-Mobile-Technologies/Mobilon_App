// ignore_for_file: depend_on_referenced_packages
import 'package:admin_page/constants/constants.dart';
import 'package:admin_page/screens/dashboard.dart';
import 'package:admin_page/screens/leaderboard_page.dart';
import 'package:admin_page/screens/login.dart';
import 'package:admin_page/screens/eventsPage.dart';
import 'package:admin_page/screens/profile_page.dart';
import 'package:admin_page/screens/qr_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/admin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Supabase with the environment variables
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
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
      initialRoute: Supabase.instance.client.auth.currentSession!=null ? '/' : '/login',
      routes: {
        '/login': (context) => const LoginPage(),
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
    );
  }
}
