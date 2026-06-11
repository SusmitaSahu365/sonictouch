import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'alert_screen.dart';
import '../utils/notification_helper.dart'; // <-- Vibration helper
import 'background_sound_detection.dart';
class SoundDetectionPage extends StatefulWidget {
  final Function(Map<String, dynamic>)? onDetect; // callback to update alert history

  const SoundDetectionPage({super.key, this.onDetect});

  @override
  _SoundDetectionPageState createState() => _SoundDetectionPageState();
}

class _SoundDetectionPageState extends State<SoundDetectionPage> with WidgetsBindingObserver {
  BackgroundSoundDetection? _backgroundDetection;
  // your existing fields ..

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  bool _isProcessing = false;
  String _predictedLabel = "Waiting...";
  Color _alertColor = Colors.grey;
  String? _audioPath;
  Timer? _loopTimer;

  // Maintain local alert history inside this page
  final List<Map<String, dynamic>> _localAlertHistory = [];

  final Map<String, Color> labelColors = {
    'air_conditioner': Colors.blue,
    'car_horn': Colors.red,
    'children_playing': Colors.orange,
    'dog_bark': Colors.brown,
    'drilling': Colors.purple,
    'engine_idling': Colors.teal,
    'gun_shot': Colors.black,
    'jackhammer': Colors.indigo,
    'siren': Colors.pink,
    'street_music': Colors.green,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _requestPermissions();
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
    setState(() {});
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception("Microphone permission not granted");
    }
  }

  Future<void> _startContinuousRecording() async {
    if (_isRecording) return;

    setState(() {
      _isRecording = true;
      _predictedLabel = "Listening...";
      _alertColor = Colors.grey;
    });

    // Detection every 4 seconds
    _loopTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      if (!_isRecording) return;
      await _recordAndDetect();
    });

    // Start immediately
    await _recordAndDetect();
  }

  Future<void> _recordAndDetect() async {
    if (_isProcessing || !_isRecording) return;

    setState(() => _isProcessing = true);

    try {
      final dir = await getTemporaryDirectory();
      _audioPath =
          "${dir.path}/clip_${DateTime.now().millisecondsSinceEpoch}.aac";

      await _recorder!.startRecorder(
        toFile: _audioPath,
        codec: Codec.aacADTS,
        sampleRate: 22050,
        numChannels: 1,
      );

      // Record for 3.5 seconds + small buffer
      await Future.delayed(const Duration(milliseconds: 3500));
      await _recorder!.stopRecorder();

      final file = File(_audioPath!);
      if (!await file.exists() || await file.length() <= 0) {
        setState(() {
          _predictedLabel = "No audio captured!";
          _alertColor = Colors.grey;
          _isProcessing = false;
        });
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('Your_backend_Ip/predict'), // Update your server
      );
      request.files.add(await http.MultipartFile.fromPath('file', _audioPath!));

      var res = await request.send();
      var resBody = await res.stream.bytesToString();

      String detectedLabel = "Unknown";
      try {
        final json = jsonDecode(resBody);
        detectedLabel = json['class'] ?? "Unknown";
      } catch (_) {}

      final color = detectedLabel.startsWith('custom_')
          ? Colors.amber
          : (labelColors[detectedLabel] ?? Colors.grey);

      setState(() {
        _predictedLabel = detectedLabel;
        _alertColor = color;
      });

      // If valid detection
      if (detectedLabel != "Unknown" && detectedLabel != "Parse error") {
        // Vibrate
        await showVibrationAlert(detectedLabel);

        // Prepare alert data
        final alertData = {
          'label': detectedLabel,
          'icon': Icons.warning,
          'color': color,
          'time': DateTime.now().toLocal().toString().split('.')[0],
        };

        // Add to local alert history
        setState(() {
          _localAlertHistory.insert(0, alertData);
        });

        // Callback to HomePage
        if (widget.onDetect != null) widget.onDetect!(alertData);

        // Show full-screen alert
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AlertScreen(
              label: "Detected: $detectedLabel",
              color: color,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _predictedLabel = "Error: $e";
        _alertColor = Colors.grey;
      });
    }

    setState(() => _isProcessing = false);
  }

  Future<void> _stopContinuousRecording() async {
    setState(() {
      _isRecording = false;
      _predictedLabel = "Stopped";
      _alertColor = Colors.grey;
    });
    _loopTimer?.cancel();
    if (_recorder != null && _recorder!.isRecording) {
      await _recorder!.stopRecorder();
    }
  }

@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (!_isRecording) return;

  if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
    // App minimized or user navigates away → start background detection
    if (_backgroundDetection == null) {
      _backgroundDetection = BackgroundSoundDetection(onDetect: (alertData) {
        setState(() {
          _localAlertHistory.insert(0, alertData);
        });
        if (widget.onDetect != null) widget.onDetect!(alertData);
      });
      _backgroundDetection!.start();
    }
  } else if (state == AppLifecycleState.resumed) {
    // App comes back to foreground → stop background detection
    _backgroundDetection?.stop();
    _backgroundDetection = null;
  }
}


  @override
  void dispose() {
     WidgetsBinding.instance.removeObserver(this); 
  _backgroundDetection?.stop(); // stop if running
    _loopTimer?.cancel();
    _recorder?.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Continuous Sound Detection")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_isRecording ? "Listening..." : "Idle",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _alertColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Detected: $_predictedLabel",
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed:
                      (_isRecording || _recorder == null) ? null : _startContinuousRecording,
                  child: const Text("Start Detection"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed:
                      (!_isRecording || _recorder == null) ? null : _stopContinuousRecording,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Stop Detection"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: _localAlertHistory.map((alert) {
                  return ListTile(
                    leading: Icon(alert['icon'], color: alert['color'] as Color),
                    title: Text(alert['label']),
                    subtitle: Text("Detected at ${alert['time']}"),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
