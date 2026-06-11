import 'package:flutter/material.dart';

//void main() => runApp(SchoolAlarmApp());

class SchoolAlarmApp extends StatelessWidget {
  const SchoolAlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SchoolAlarmScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SchoolAlarmScreen extends StatelessWidget {
  const SchoolAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[600],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SCHOOL ALARM',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Icon(
              Icons.notifications_active,
              size: 100,
              color: Colors.black,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Text(
                  'BREAK TIME!!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}