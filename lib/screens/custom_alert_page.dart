import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CustomAlertPage extends StatefulWidget {
  const CustomAlertPage({super.key});

  @override
  State<CustomAlertPage> createState() => _CustomAlertPageState();
}

class _CustomAlertPageState extends State<CustomAlertPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  bool _isUploading = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _requestPermissions();
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
  }

  Future<void> _requestPermissions() async {
    var micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      throw Exception("Microphone permission not granted");
    }
    await Permission.storage.request();
  }

  Future<void> _startRecording() async {
    final dir = await getTemporaryDirectory();
    _audioPath = "${dir.path}/custom_alert.aac";

    await _recorder!.startRecorder(
      toFile: _audioPath,
      codec: Codec.aacADTS,
      sampleRate: 22050,
      numChannels: 1,
    );

    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    await _recorder!.stopRecorder();
    setState(() => _isRecording = false);
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _audioPath = result.files.single.path!;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Audio file selected successfully")),
      );
    }
  }

  Future<void> _uploadCustomSound() async {
    if (_audioPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please record or select a file first!")),
      );
      return;
    }

    setState(() => _isUploading = true);

    final file = File(_audioPath!);
    if (!await file.exists()) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Audio file not found")),
      );
      return;
    }

    try {
      // 🔗 Change this to your Render-hosted Flask backend URL
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('Your_backend_Ip/upload_custom'),
      );

      // Send the file and alert name
      request.files.add(await http.MultipartFile.fromPath('file', _audioPath!));
      request.fields['alert_name'] = _nameController.text;

      var res = await request.send();
      var resBody = await res.stream.bytesToString();

      setState(() => _isUploading = false);
      print('Upload response: $resBody');

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ File uploaded successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Upload failed: ${res.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error uploading: $e")),
      );
    }
  }

  Future<void> _saveAlert() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final alertData = {
          "name": _nameController.text,
          "createdAt": DateTime.now().toIso8601String(),
        };

        await FirebaseDatabase.instance
            .ref("users/${user.uid}/customAlerts")
            .push()
            .set(alertData);

        await _uploadCustomSound();

        if (mounted) Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Custom Alert")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Alert Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter alert name" : null,
              ),
              const SizedBox(height: 24),

              // 🎙️ Recording controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isRecording ? null : _startRecording,
                    icon: const Icon(Icons.mic),
                    label: const Text("Start Recording"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: !_isRecording ? null : _stopRecording,
                    icon: const Icon(Icons.stop),
                    label: const Text("Stop Recording"),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 📂 Upload file option
              ElevatedButton.icon(
                onPressed: _pickAudioFile,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload a File"),
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isUploading ? null : _saveAlert,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save & Upload Alert"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}