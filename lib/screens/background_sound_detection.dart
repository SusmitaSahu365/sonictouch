// background_sound_detection.dart
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../utils/notification_helper.dart'; // your vibration/notification helper

class BackgroundSoundDetection {
  FlutterSoundRecorder? _recorder;
  Timer? _loopTimer;
  bool _isRecording = false;

  /// Callback to report detected alerts
  final Function(Map<String, dynamic>)? onDetect;

  BackgroundSoundDetection({this.onDetect});

  /// Start the background detection service
  Future<void> start() async {
    if (_isRecording) return;
    _isRecording = true;

    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
    await Permission.microphone.request();

    // Start detection every 4 seconds
    _loopTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      if (!_isRecording) return;
      await _recordAndDetect();
    });

    // Start immediately
    await _recordAndDetect();
  }

  /// Stop the background detection
  Future<void> stop() async {
    _isRecording = false;
    _loopTimer?.cancel();
    if (_recorder != null && _recorder!.isRecording) {
      await _recorder!.stopRecorder();
    }
    _recorder?.closeRecorder();
  }

  /// Record a short audio clip and send to server
  Future<void> _recordAndDetect() async {
    if (!_isRecording) return;

    try {
      final dir = await getTemporaryDirectory();
      final audioPath =
          "${dir.path}/clip_${DateTime.now().millisecondsSinceEpoch}.aac";

      await _recorder!.startRecorder(
        toFile: audioPath,
        codec: Codec.aacADTS,
        sampleRate: 22050,
        numChannels: 1,
      );

      // Record 3.5 seconds
      await Future.delayed(const Duration(milliseconds: 3500));
      await _recorder!.stopRecorder();

      final file = File(audioPath);
      if (!await file.exists() || await file.length() <= 0) return;

      // Send audio to server
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('Your_backend_Ip/predict'), // update your server
      );
      request.files.add(await http.MultipartFile.fromPath('file', audioPath));

      var res = await request.send();
      var resBody = await res.stream.bytesToString();

      String detectedLabel = "Unknown";
      try {
        final json = jsonDecode(resBody);
        detectedLabel = json['class'] ?? "Unknown";
      } catch (_) {}

      if (detectedLabel != "Unknown" && detectedLabel != "Parse error") {
        // Vibrate + notification
        await showVibrationAlert(detectedLabel); // from your helper

        // Prepare alert data
        final alertData = {
          'label': detectedLabel,
          'icon': Icons.warning,
          'color': detectedLabel.startsWith('custom_') ? Colors.amber : Colors.red,
          'time': DateTime.now().toLocal().toString().split('.')[0],
        };

        // Callback to update UI or HomePage
        if (onDetect != null) onDetect!(alertData);
      }
    } catch (e) {
      print("Background detection error: $e");
    }
  }
}
