import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'custom_alert_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'sound_detection_page.dart'; // ✅ Import SoundDetectionPage

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fullName = '';
  String email = '';
  bool isLoading = true;

  // Manual alerts
  final List<Map<String, dynamic>> alerts = [
    {'icon': Icons.local_fire_department, 'color': Colors.red, 'label': 'Fire Alarm'},
    {'icon': Icons.school, 'color': Colors.orange, 'label': 'School Alarm'},
    {'icon': Icons.wb_sunny, 'color': Colors.amber, 'label': 'Morning Wake-Up'},
  ];

  // CNN supported sounds
  final List<Map<String, dynamic>> supportedSounds = [
    {'icon': Icons.directions_car, 'label': 'Car Horn'},
    {'icon': Icons.pets, 'label': 'Dog Bark'},
    {'icon': Icons.build, 'label': 'Drilling'},
    {'icon': Icons.sports_kabaddi, 'label': 'Gun Shot'},
    {'icon': Icons.record_voice_over, 'label': 'Speech'},
    {'icon': Icons.music_note, 'label': 'Music'},
    {'icon': Icons.child_care, 'label': 'Children Playing'},
    {'icon': Icons.surround_sound, 'label': 'Siren'},
    {'icon': Icons.construction, 'label': 'Jackhammer'},
    {'icon': Icons.meeting_room, 'label': 'Door Knock'},
  ];

  // History of detected alerts
  final List<Map<String, dynamic>> alertHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot =
          await FirebaseDatabase.instance.ref('users/${user.uid}').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          fullName = data['fullName'] ?? '';
          email = data['email'] ?? '';
          isLoading = false;
        });
      }
    }
  }

  // ✅ Body with collapsible lists
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Home screen title
            Row(
              children: const [
                Icon(Icons.home, size: 32, color: Colors.black54),
                SizedBox(width: 8),
                Text(
                  'Home screen',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Profile card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue[200],
                    child: const Icon(Icons.person, size: 32, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ✅ Collapsible Alerts
            ExpansionTile(
              title: const Text(
                "Select Alert",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              leading: const Icon(Icons.notifications, color: Colors.red),
              children: [
                ...alerts.map((alert) => ListTile(
                      leading: Icon(alert['icon'], color: alert['color']),
                      title: Text(alert['label']),
                      onTap: () {
                        // TODO: Trigger alert logic
                      },
                    )),
                ListTile(
                  leading: const Icon(Icons.add_alert, color: Colors.blueGrey),
                  title: const Text("Custom Alert"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CustomAlertPage()),
                    );
                  },
                ),
                // ✅ New Sound Detection button
ListTile(
  leading: const Icon(Icons.hearing, color: Colors.deepPurple),
  title: const Text("Start Sound Detection"),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SoundDetectionPage(
          onDetect: (alertData) {
            setState(() {
              alertHistory.insert(0, alertData); // update in real-time
            });
          },
        ),
      ),
    );
  },
),

              ],
            ),
            const SizedBox(height: 20),

            // ✅ Collapsible Supported Sounds
            ExpansionTile(
              title: const Text(
                "Supported Sounds",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              leading: const Icon(Icons.library_music, color: Colors.deepPurple),
              children: supportedSounds
                  .map((sound) => ListTile(
                        leading: Icon(sound['icon'], color: Colors.blue),
                        title: Text(sound['label']),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // ✅ Collapsible Alert History
            ExpansionTile(
              title: const Text(
                "Alert History",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              leading: const Icon(Icons.history, color: Colors.teal),
              children: alertHistory.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "No alerts detected yet.",
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    ]
                  : alertHistory
                      .map((alert) => ListTile(
                            leading: Icon(alert['icon'], color: alert['color']),
                            title: Text(alert['label']),
                            subtitle: Text(
                              "Detected at ${alert['time'] ?? 'unknown'}",
                            ),
                          ))
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3D6F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Opens Drawer
              },
            );
          },
        ),
      ),

      // ✅ Drawer Navigation
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF1976D2)),
              accountName: Text(fullName, style: const TextStyle(fontSize: 18)),
              accountEmail: Text(email),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.black87),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context); // stay on Home
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About"),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Alert App",
                  applicationVersion: "1.0.0",
                  children: [
                    const Text(
                      "This app detects and manages alerts with sound recognition.",
                    ),
                  ],
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // Navigate back to login screen
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }
}