import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double micSensitivity = 0.5;
  double classificationFrequency = 1.0; // in seconds
  bool alertVibration = true;
  bool alertSound = true;
  bool loggingEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("Microphone Sensitivity", style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: micSensitivity,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: (micSensitivity * 100).toInt().toString(),
            onChanged: (val) {
              setState(() {
                micSensitivity = val;
              });
            },
          ),
          const SizedBox(height: 16),
          Text("Classification Frequency (sec)", style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: classificationFrequency,
            min: 0.5,
            max: 5.0,
            divisions: 9,
            label: classificationFrequency.toStringAsFixed(1),
            onChanged: (val) {
              setState(() {
                classificationFrequency = val;
              });
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text("Vibration Alert"),
            value: alertVibration,
            onChanged: (val) {
              setState(() {
                alertVibration = val;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Sound Alert"),
            value: alertSound,
            onChanged: (val) {
              setState(() {
                alertSound = val;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Enable Logging / Feedback"),
            value: loggingEnabled,
            onChanged: (val) {
              setState(() {
                loggingEnabled = val;
              });
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.blue),
            title: const Text("About App"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Sound Classifier",
                applicationVersion: "1.0.0",
                children: const [
                  Text(
                    "This app detects and classifies sounds in real-time, "
                    "and notifies you according to your preferences.",
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
