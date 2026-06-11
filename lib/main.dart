import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // 🆕 Added
import 'firebase_options.dart';

// Import your screens
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/homepage.dart';
import 'screens/firealarm.dart';
import 'screens/morningalarm.dart';
import 'screens/schoolalaram.dart';
import 'screens/custom_alert_page.dart';
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';
import 'screens/sound_detection_page.dart'; // <-- Added

// 🆕 Create a global notifications plugin instance
final FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: 'SonicTouchApp',
  );

  // 🆕 Initialize local notifications
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await notifications.initialize(initSettings);

  runApp(const SonicTouchApp());
}

class SonicTouchApp extends StatelessWidget {
  const SonicTouchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonic Touch',
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const CreateAccountPage(),
        '/home': (context) => HomePage(),
        '/customalert': (context) => CustomAlertPage(),
        '/firealarm': (context) => DangerScreen(),
        '/morning_alarm': (context) => const GoodMorningScreen(),
        '/schoolalarm': (context) => const SchoolAlarmScreen(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/sound_detection': (context) => SoundDetectionPage(),
      },
    );
  }
}

/// Decides which page to show based on login state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return const HomePage(); // Already logged in
    } else {
      return const LoginPage(); // Not logged in
    }
  }
}
