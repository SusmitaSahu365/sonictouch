import 'package:flutter/material.dart';

//void main() => runApp(GoodMorningApp());

class GoodMorningApp extends StatelessWidget {
  const GoodMorningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoodMorningScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GoodMorningScreen extends StatelessWidget {
  const GoodMorningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.purple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wb_sunny,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                'GOOD MORNING!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              Icon(
                Icons.graphic_eq,
                size: 60,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                'Wake Up Alarm & ringing.',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}