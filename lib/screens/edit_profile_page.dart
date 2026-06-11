import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String password = '';
  String confirmPassword = '';
  bool vibrationAlert = true;
  bool soundAlert = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => name = val,
                validator: (val) =>
                    val!.isEmpty ? "Name cannot be empty" : null,
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => password = val,
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => confirmPassword = val,
                validator: (val) {
                  if (password.isNotEmpty && val != password) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Vibration Alert Toggle
              SwitchListTile(
                title: const Text("Vibration Alerts"),
                value: vibrationAlert,
                onChanged: (val) => setState(() => vibrationAlert = val),
              ),

              // Sound Alert Toggle
              SwitchListTile(
                title: const Text("Sound Alerts"),
                value: soundAlert,
                onChanged: (val) => setState(() => soundAlert = val),
              ),

              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save profile changes logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile updated!")),
                    );
                  }
                },
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
