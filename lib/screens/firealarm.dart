import 'package:flutter/material.dart';

//void main() => runApp(EmergencyAlertApp());

class EmergencyAlertApp extends StatelessWidget {
  const EmergencyAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency Alert',
      home: DangerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DangerScreen extends StatelessWidget {
  final Color backgroundColor = Colors.red.shade700;

  DangerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_active,
                  size: 80,
                  color: Colors.yellowAccent,
                ),
                SizedBox(height: 20),
                Text(
                  'CAUTION! YOU\'RE IN DANGER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'EVACUATE IMMEDIATELY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Text(
                    'EVACUATED SUCCESSFULLY',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
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