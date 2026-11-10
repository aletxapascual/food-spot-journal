# Food Spot Journal

Midterm 2 project for Mobile Development (Flutter).

An offline journal for local food spots that don't appear on Google Maps: street stalls, market stands and small family restaurants. Each entry stores a photo of the dish, a voice-dictated review and the exact GPS location.

## Features

| Requirement | Implementation |
|---|---|
| 1. Scaffold, AppBar, Drawer, navigation, Hero | Named routes (`/`, `/detail`, `/add`), Drawer in its own widget, Hero animation of the dish photo from list to detail |
| 2. SQLite with metadata | `sqflite` table storing name, review, image path, latitude, longitude and date; `try-catch` and `FutureBuilder` |
| 3. Camera and gallery | `image_picker`; the photo is copied to the app documents folder with `path_provider` |
| 4. Voice dictation | `speech_to_text` microphone button in the review field |
| 5. GPS and map | `geolocator` captures the position when saving; `flutter_map` + OpenStreetMap shows it in the detail view |

If the camera, microphone or location permission is denied, the app shows a message and the spot can still be saved.

## Project structure

```
lib/
├── main.dart                   App root and named routes
├── models/
│   └── food_spot.dart          FoodSpot data class (fromMap / toMap)
├── data/
│   └── database_helper.dart    Singleton SQLite connection and queries
├── services/
│   ├── camera_service.dart     Camera / gallery and permanent photo storage
│   ├── speech_service.dart     Voice-to-text dictation
│   └── location_service.dart   GPS with defensive permission flow
├── screens/
│   ├── home_screen.dart        List of food spots
│   ├── detail_screen.dart      Photo, review and map of one spot
│   └── add_spot_screen.dart    Form to create a spot
└── widgets/
    ├── app_drawer.dart         Side menu
    ├── food_spot_card.dart     List item with Hero photo
    ├── spot_image.dart         Photo or placeholder
    └── food_spot_map.dart      Interactive map with marker
```

- **Models**: plain data classes that convert to and from database rows.
- **Data**: a single shared SQLite connection (Singleton pattern).
- **Services**: each one wraps a device feature and throws clear exceptions that the screens catch.
- **Screens**: load data with `FutureBuilder`, navigate with named routes and update with `setState`.
- **Widgets**: reusable UI pieces with a single responsibility.

## Packages

- `sqflite`, `path` - local database
- `path_provider` - app documents folder for photos
- `image_picker` - camera and gallery
- `speech_to_text` - voice dictation
- `geolocator` - GPS position
- `flutter_map`, `latlong2` - OpenStreetMap map (no API key required)

## Running the app

```bash
flutter pub get
flutter run
```

On the Android emulator:

- **Location**: Extended controls > Location > set a point on the map.
- **Microphone**: Extended controls > Microphone > enable "Virtual microphone uses host audio input". Use an emulator image with Google Play for speech recognition.
- **Camera**: the emulator camera shows a virtual scene that can be photographed.

The map needs an internet connection to download tiles. Everything else works offline.
