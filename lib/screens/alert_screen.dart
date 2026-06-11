import 'package:flutter/material.dart';

class AlertScreen extends StatelessWidget {
  final String label;
  final Color color;

  const AlertScreen({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: color,
        body: Stack(
          children: [
            // Animated background overlay
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: 0.7,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        color.withOpacity(0.9),
                        color,
                      ],
                      radius: 1.0,
                      center: Alignment.center,
                    ),
                  ),
                ),
              ),
            ),
            // Alert content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 100,
                    shadows: [
                      Shadow(
                        blurRadius: 20,
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "ALERT!",
                    style: TextStyle(
                      fontSize: 54,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(
                          blurRadius: 12,
                          color: Colors.black.withOpacity(0.7),
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black45,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "Tap anywhere to dismiss",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black38,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}