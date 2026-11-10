import 'package:speech_to_text/speech_to_text.dart';

/// Turns the user's voice into text using the device speech recognizer.
class SpeechService {
  final SpeechToText _speech = SpeechToText();

  /// Asks for microphone permission and prepares the recognizer.
  /// [onListeningChanged] is called when listening starts or stops.
  /// Returns false if permission was denied or recognition is unavailable.
  Future<bool> initialize(void Function(bool isListening) onListeningChanged) async {
    try {
      return await _speech.initialize(
        onStatus: (status) => onListeningChanged(status == SpeechToText.listeningStatus),
        onError: (error) => onListeningChanged(false),
      );
    } catch (e) {
      return false;
    }
  }

  /// Starts listening and sends the recognized words to [onResult].
  Future<void> startListening(void Function(String words) onResult) async {
    await _speech.listen(onResult: (result) => onResult(result.recognizedWords));
  }

  /// Stops listening; the last recognized words are still delivered.
  Future<void> stopListening() async {
    await _speech.stop();
  }
}
