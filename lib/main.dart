import 'package:admin_page/constants/constants.dart';
import 'package:admin_page/screens/admin_screens/admin_dash.dart';
import 'package:admin_page/screens/bottom_navbar.dart';
import 'package:admin_page/screens/admin_screens/create_event.dart';
import 'package:admin_page/screens/admin_screens/login_new.dart';
import 'package:admin_page/screens/dashboard.dart';
import 'package:admin_page/screens/admin_screens/edit_event.dart';
import 'package:admin_page/screens/leaderboard_page.dart';
// import 'package:admin_page/screens/login.dart';
import 'package:admin_page/screens/profile_page.dart';
import 'package:admin_page/screens/qr_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


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
      initialRoute: Supabase.instance.client.auth.currentSession != null ? '/' : '/login',
      routes: {
        '/': (context) => BottomNavigationPage(userType: 'Student'),
        '/login': (context) => const LoginPage(),
        '/Dashboard': (context) => DashboardPage(userType: (ModalRoute.of(context)?.settings.arguments as String?) ?? "defaultUserType"),
        '/Dashboard/qr': (context) => const QRPage(title: "QR Page"),
        '/leaderboard': (context) => const LeaderboardPage(title: "Leaderboards"),
        '/profile': (context) => const ProfilePage(userType: 'Student'),
        '/admin_dash': (context) => const AdminDash(userType: 'Admin'),
        '/create_event': (context) => const CreateEventScreen(),
        '/edit_event': (context) => const EditEventScreen(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
    );
  }
}