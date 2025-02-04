import 'package:admin_page/empty_page.dart';
import 'package:admin_page/leaderboard_page.dart';
import 'package:admin_page/qr_page.dart';
import 'admin_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const RSVPApp());
}

class RSVPApp extends StatelessWidget {
  const RSVPApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AdminPage',
      initialRoute: '/',
      routes: {
        '/' : (context) => const EmptyPage(title: "Home"),
        '/admin' : (context) => const AdminPage(title: "Admin"),
        '/Dashboard/qr' : (context) => const QRPage(title: "QR Page"),
        '/leaderboard' : (context) => const LeaderboardPage(title: "Leaderboards"),
        //Pages...
      },
      theme: ThemeData(
        //brightness not necessary, but i kept it for hover and tap effects
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
    );
  }
}




