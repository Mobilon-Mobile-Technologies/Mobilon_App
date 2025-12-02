import 'package:eventa/constants/constants.dart';
import 'package:eventa/functions/admin_priveleges.dart';
import 'package:eventa/screens/admin_screens/admin_dash.dart';
import 'package:eventa/screens/bottom_navbar.dart';
import 'package:eventa/screens/admin_screens/create_event.dart';
import 'package:eventa/screens/admin_screens/login_new.dart';
import 'package:eventa/screens/dashboard.dart';
import 'package:eventa/screens/admin_screens/edit_event.dart';
import 'package:eventa/screens/qr_reserve.dart';
import 'package:eventa/screens/leaderboard_page.dart';
import 'package:eventa/screens/profile_page.dart';
import 'package:eventa/screens/qr_page.dart';
import 'package:eventa/screens/qr_scanner_reserve.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/events.dart';
import 'package:app_links/app_links.dart';
import 'constants/is_logged_in_as_admin.dart' as AdminStatus;
import 'screens/admin_screens/qr_scanner_entry.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with the environment variables
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );

  runApp(const RSVPApp());
}

class RSVPApp extends StatefulWidget {
  const RSVPApp({super.key});

  @override
  State<RSVPApp> createState() => _RSVPAppState();
}

class _RSVPAppState extends State<RSVPApp> {
  late AppLinks? _appLinks;

  @override
  void initState() {
    super.initState();
    
    // Only initialize AppLinks for mobile platforms
    if (!kIsWeb) {
      _appLinks = AppLinks();
      _initAppLinks();
    } else {
      _appLinks = null;
      _initWebAuth();
    }
    
    _initAuthListener();
  }

  void _initWebAuth() {
    // On web, Supabase automatically handles OAuth callbacks
    // Just check if user is already logged in
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      print('Web: User already logged in: ${session.user.email}');
    }
  }

  void _initAuthListener() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      print('Auth state change: $event');
      
      if (event == AuthChangeEvent.signedIn && session != null) {
        print('User signed in: ${session.user.email}');

        AdminStatus.setAdminStatus().then((_) {
          print('Admin status set to: ${AdminStatus.is_admin}');
          
          // Use the global navigator key instead of context
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState?.pushReplacementNamed('/');
          });
        });
      }
    });
  }

  void _initAppLinks() {
    if (_appLinks == null) return;
    
    _appLinks!.uriLinkStream.listen((uri) {
      print('Received deep link: $uri');
      
      
      // Handle OAuth login callback
      if (uri.scheme == 'io.supabase.flutterquickstart' && uri.host == 'login-callback') {
        _handleOAuthCallback();
      }
    });
  }

  void _handleOAuthCallback() async {
    if (!mounted) return;
    
    await Future.delayed(const Duration(milliseconds: 500));
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      print('Login successful - User: ${session.user.email}');
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      print('OAuth callback received but no session found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [DashboardPageState.routeObserver], // Add this
      debugShowCheckedModeBanner: false,
      title: 'Eventa',
      initialRoute: Supabase.instance.client.auth.currentSession != null ? '/' : '/login',
      routes: {
        '/': (context) => FutureBuilder<bool>(
          future: isAdmin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Eventa_transparent.png',
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(
                        width: 100,
                        height: 5,
                        child: LinearProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              );
            }
            return BottomNavigationPage(userType: snapshot.data == true ? 'Admin' : 'Student');
          },
        ),
        '/login': (context) => const LoginPage(),
        '/Dashboard': (context) => DashboardPage(userType: (ModalRoute.of(context)?.settings.arguments as String?) ?? "defaultUserType"),
        '/Dashboard/qr': (context) {
          final event = ModalRoute.of(context)!.settings.arguments as Events;
          return QRPage(event: event);
        },
        '/leaderboard': (context) => const LeaderboardPage(title: "Leaderboards"),
        '/profile': (context) => const ProfilePage(userType: 'Student'),
        '/admin_dash': (context) => const AdminDash(userType: 'Admin'),
        '/create_event': (context) => const CreateEventScreen(),
        '/edit_event': (context) {
          final event = ModalRoute.of(context)!.settings.arguments as Events;
          return EditEventScreen(event: event);
        },
        '/qr_scanner': (context) => const QRScannerPage(),
        '/reserve_qr': (context) => const QRReservationPage(),
        '/event_details': (context) {
          final event = ModalRoute.of(context)!.settings.arguments as Events;
          return EventDetailsScreen(event: event);
        },
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
    );
  }
}