<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" />
  <img src="https://img.shields.io/badge/Firebase-Auth%20%2B%20DB-orange?logo=firebase" />
  <img src="https://img.shields.io/badge/TensorFlow-CNN%20Model-yellow?logo=tensorflow" />
  <img src="https://img.shields.io/badge/Platform-Android-green?logo=android" />
  <img src="https://img.shields.io/badge/Purpose-Assistive%20Technology-purple" />
</p>

<h1 align="center">🎧 SonicTouch</h1>
<p align="center"><b>AI-Powered Assistive Sound Recognition App for the Hearing Impaired</b></p>
<p align="center">
  SonicTouch listens to your surroundings and instantly alerts you through full-screen visuals and vibration patterns when important sounds are detected — designed for deaf and hard-of-hearing individuals.
</p>

---

## 📱 Demo

| Home Screen | Sound Detection | Alert Screen |
|---|---|---|
| Dashboard with profile, alert types, and history | Real-time CNN-based sound classification | Full-screen color-coded visual alert |

> 📥 **[Download Latest APK](https://github.com/SusmitaSahu365/sonictouch-flutter/releases/latest)**

---

## 🌟 Features

| Feature | Description |
|---|---|
| 🔊 **Real-time Detection** | Continuously records and classifies audio every 4 seconds |
| 🚨 **Full-screen Alerts** | Color-coded full-screen alert with sound label on detection |
| 📳 **Vibration Patterns** | Strong custom vibration patterns — no sound needed |
| 🔔 **Push Notifications** | Local notifications even when screen is off |
| 🎙️ **Custom Sound Registration** | Record or upload your own reference sounds |
| 🔕 **Background Detection** | Keeps detecting when app is minimized |
| 📜 **Alert History** | Timestamped log of all detected sounds |
| 👤 **User Accounts** | Firebase Auth — login, signup, profile management |
| ⚙️ **Settings** | Mic sensitivity, classification frequency, alert toggles |

---

## 🧠 How It Works

```
📱 Flutter App
     │
     ▼
🎙️ Record 3.5s audio clip (every 4 seconds)
     │
     ▼
☁️  POST /predict → Flask Backend (Python)
     │
     ▼
🔄 Convert audio → Mel Spectrogram (128x128)
     │
     ▼
🤖 CNN Model inference (TensorFlow/Keras)
     │
     ▼
📊 Returns predicted class + confidence score
     │
     ▼
🚨 If Dog Bark / Car Horn / Siren → ALERT!
     │
     ▼
📳 Vibration + Notification + Full-screen Alert UI
```

---

## 🔊 Supported Sound Classes

The CNN model is trained on the **UrbanSound8K** dataset and recognizes 10 urban sound classes:

| Sound | Label | Triggers Alert |
|---|---|---|
| 🚗 Car Horn | `car_horn` | ✅ Yes |
| 🐕 Dog Bark | `dog_bark` | ✅ Yes |
| 🚨 Siren | `siren` | ✅ Yes |
| ❄️ Air Conditioner | `air_conditioner` | ❌ No |
| 👶 Children Playing | `children_playing` | ❌ No |
| 🔨 Drilling | `drilling` | ❌ No |
| 🚗 Engine Idling | `engine_idling` | ❌ No |
| 🔫 Gun Shot | `gun_shot` | ❌ No |
| 🔧 Jackhammer | `jackhammer` | ❌ No |
| 🎵 Street Music | `street_music` | ❌ No |

> Custom sounds registered by the user are matched using **MFCC cosine similarity**.

---

## 🛠️ Tech Stack

### Frontend
| Technology | Purpose |
|---|---|
| **Flutter (Dart)** | Cross-platform mobile UI |
| **flutter_sound** | Audio recording |
| **flutter_local_notifications** | Push notifications + vibration |
| **permission_handler** | Microphone permissions |
| **http** | REST API calls to Flask backend |
| **file_picker** | Upload custom audio files |

### Backend & Cloud
| Technology | Purpose |
|---|---|
| **Firebase Auth** | User login / signup |
| **Firebase Realtime Database** | User profiles + alert metadata |
| **Flask (Python)** | REST API server |
| **TensorFlow/Keras** | CNN model inference |
| **librosa** | Audio feature extraction (Mel Spectrogram, MFCC) |
| **pydub** | Audio format conversion |

---

## 📁 Project Structure

```
sonictouch-flutter/
├── lib/
│   ├── main.dart                          # App entry, Firebase init, notifications setup
│   ├── screens/
│   │   ├── homepage.dart                  # Main dashboard — alerts, history, navigation
│   │   ├── sound_detection_page.dart      # Core real-time detection loop
│   │   ├── background_sound_detection.dart # Detection when app is minimized
│   │   ├── alert_screen.dart              # Full-screen alert UI
│   │   ├── custom_alert_page.dart         # Record/upload custom sounds
│   │   ├── login.dart                     # Firebase Auth login
│   │   ├── signup.dart                    # Firebase Auth signup
│   │   ├── profile_page.dart              # View user profile
│   │   ├── edit_profile_page.dart         # Edit name, password, preferences
│   │   ├── settings_page.dart             # App-wide settings
│   │   ├── firealarm.dart                 # Fire alarm alert screen
│   │   ├── morningalarm.dart              # Morning alarm screen
│   │   └── schoolalaram.dart              # School alarm screen
│   └── utils/
│       ├── notification_helper.dart       # Vibration + local notification logic
│       └── alert_callback.dart            # Alert callback typedef
├── android/                               # Android-specific config
├── pubspec.yaml                           # Flutter dependencies
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.x or above → [Install Flutter](https://flutter.dev/docs/get-started/install)
- Android Studio or VS Code
- Android device or emulator (API 21+)
- Firebase project (Auth + Realtime Database enabled)

### 1. Clone the repository

```bash
git clone https://github.com/SusmitaSahu365/sonictouch-flutter.git
cd sonictouch-flutter
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

- Download `google-services.json` from your Firebase Console
- Place it in `android/app/`

### 4. Configure Backend URL

Update the API base URL in these files to point to your Flask backend:

```dart
// lib/screens/sound_detection_page.dart
// lib/screens/background_sound_detection.dart
Uri.parse('https://your-backend-url/predict')

// lib/screens/custom_alert_page.dart
Uri.parse('https://your-backend-url/upload_custom_sound')
```

### 5. Run the app

```bash
flutter run
```

### 6. Build release APK

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🔗 Backend

The CNN model and Flask API are in a separate repository:

👉 **[sonictouch-backend](https://github.com/SusmitaSahu365/sonictouch-backend)**

- Built with Flask + TensorFlow
- Accepts audio → returns predicted class + confidence
- Supports custom sound upload and MFCC-based matching

---

## 🔐 Permissions Required

| Permission | Reason |
|---|---|
| `RECORD_AUDIO` | Microphone access for sound detection |
| `VIBRATE` | Vibration alerts on sound detection |
| `INTERNET` | API calls to Flask backend + Firebase |
| `FOREGROUND_SERVICE` | Background sound detection |
| `RECEIVE_BOOT_COMPLETED` | Restart detection service on reboot |

---

## 📄 Key Dependencies

```yaml
flutter_sound: ^9.x         # Audio recording
flutter_local_notifications  # Notifications + vibration
firebase_auth                # User authentication
firebase_database            # Realtime user data
permission_handler           # Runtime permissions
http                         # REST API calls
file_picker                  # Upload custom audio
vibration                    # Haptic feedback
path_provider                # Temp file storage
```

---

## 🎯 Use Case

SonicTouch is designed as an **assistive technology** tool. Target users include:

- Deaf and hard-of-hearing individuals
- People in noisy environments who need sound alerts
- Anyone who needs passive ambient sound monitoring

---

## 👩‍💻 Developer

**Susmita Sahu**  
B.E. Computer Engineering  
GitHub: [@SusmitaSahu365](https://github.com/SusmitaSahu365)

---

## 📄 License

This project is developed for academic and demonstration purposes.

---

<p align="center">Made with ❤️ for accessibility</p>
