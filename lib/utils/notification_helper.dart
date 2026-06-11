import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart'; // uses the global `notifications` instance

Future<void> showVibrationAlert(String label) async {
  // 🆕 Channel details — make sure name & id are unique to force recreation
   AndroidNotificationChannel channel = AndroidNotificationChannel(
    'detect_channel_v2', // change ID when updating vibration/sound behavior
    'Detection Alerts',
    description: 'Alerts when a specific sound is detected',
    importance: Importance.max,
    playSound: true, // ✅ enables sound
    enableVibration: true,
    vibrationPattern: Int64List.fromList([0, 500, 200, 500, 200, 800]),
  );

  // 🧩 Ensure the channel exists (recreate with updated config)
  await notifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    channel.id,
    channel.name,
    channelDescription: channel.description,
    importance: Importance.max,
    priority: Priority.high,
    playSound: true, // ✅ sound enabled
    enableVibration: true,
    vibrationPattern: channel.vibrationPattern,
    icon: '@mipmap/ic_launcher',
  );

  final NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  // 🆕 Use unique ID to avoid suppression by Android
  final int uniqueId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

  await notifications.show(
    uniqueId,
    'Sound Detected',
    'Detected: $label',
    notificationDetails,
  );
}
