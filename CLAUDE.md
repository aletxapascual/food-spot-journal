# Midterm 2 - Mobile Development (Flutter)

## App
Food Spot Journal: an offline journal to save local food spots that don't appear on Google Maps (street stalls, market stands, small family restaurants), with a photo of the dish, a voice-dictated review and the exact GPS location.

## Code rules
- Before writing any code, review the referencias/ folder. Only use the packages and patterns from the professor's examples and my previous assignments.
- Minimal code. No patterns, libraries or decorations that are not in referencias/ unless a requirement demands it.
- No state management packages. Use StatefulWidget and setState like the professor.
- Layered structure: lib/models, lib/data (Singleton DatabaseHelper with sqflite), lib/services (camera, speech, location), lib/screens, lib/widgets.
- Short comments per class and public method, following SOLID. No decorative comments.
- Error handling with try-catch and data loading with FutureBuilder.
- Defensive permission handling for camera, microphone and location. If denied, show a message and keep working.
- Run flutter analyze after every change and fix any errors.
- All code, comments, UI text and documentation in English.

## Packages
- sqflite and path for the database.
- path_provider to copy images to the app documents folder.
- image_picker for camera and gallery.
- speech_to_text for voice dictation.
- geolocator for GPS, using the defensive permission flow from the professor's LocationService.
- flutter_map and latlong2 for the map in the detail view (professor's example, no API key required).

## Git
- One commit per working feature, with a descriptive message in English.

## Way of working
- Work in phases and stop after each one so I can test it on the emulator.
- Explain each layer to me when you finish it, because I have to defend the project in the exam.