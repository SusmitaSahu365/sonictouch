import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class VibrationTestPage extends StatefulWidget {
  const VibrationTestPage({super.key});

  @override
  State<VibrationTestPage> createState() => _VibrationTestPageState();
}

class _VibrationTestPageState extends State<VibrationTestPage> {
  String _status = "Press the button to test vibration";

  Future<void> _testVibration() async {
    bool? canVibrate = await Vibration.hasVibrator();
    bool? hasCustomVibrationSupport = await Vibration.hasCustomVibrationsSupport();

    if (canVibrate == true) {
      setState(() {
        _status = "✅ Device supports vibration";
      });

      // Vibrate for 1 second
      //Vibration.vibrate(duration: 1500);

      // You can also try a pattern:
      Vibration.vibrate(pattern: [0, 1500, 200, 500]);

      print("✅ Vibrating for 1 second!");
      print("Custom vibration supported: $hasCustomVibrationSupport");
    } else {
      setState(() {
        _status = "❌ No vibration hardware found";
      });
      print("❌ This device or emulator cannot vibrate");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vibration Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _status,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.vibration),
              label: const Text("Test Vibration"),
              onPressed: _testVibration,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
