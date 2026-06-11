import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecorderTestPage extends StatefulWidget {
  const RecorderTestPage({super.key});

  @override
  State<RecorderTestPage> createState() => _RecorderTestPageState();
}

class _RecorderTestPageState extends State<RecorderTestPage> {
  final _recorder = FlutterSoundRecorder();
  String _status = "Idle";

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  Future<void> _record() async {
    final dir = await getTemporaryDirectory();
    final path = "${dir.path}/test.wav";
    try {
      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.pcm16WAV,
      );
      setState(() => _status = "Recording for 3 seconds...");
      await Future.delayed(const Duration(seconds: 3));
      await _recorder.stopRecorder();

      final size = await File(path).length();
      setState(() => _status = "✅ Saved: $size bytes\nPath: $path");
      debugPrint("🎙️ File saved: $path ($size bytes)");
    } catch (e) {
      setState(() => _status = "❌ Error: $e");
      debugPrint("🔥 Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mic Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _status,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _record,
              child: const Text("Record 3s"),
            ),
          ],
        ),
      ),
    );
  }
}
