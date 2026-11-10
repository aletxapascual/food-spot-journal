import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Takes dish photos with the camera or gallery and stores them
/// permanently in the app documents folder.
class CameraService {
  final ImagePicker _picker = ImagePicker();

  /// Opens the camera or gallery. Returns the temporary path of the photo,
  /// or null if the user cancelled. Throws an Exception if access fails.
  Future<String?> pickImage(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(source: source, maxWidth: 1200);
      return photo?.path;
    } on PlatformException catch (e) {
      if (e.code.contains('access_denied')) {
        throw Exception('Permission denied. You can still save the spot without a photo.');
      }
      throw Exception('Could not open the ${source.name}: ${e.message}');
    }
  }

  /// Copies a temporary photo into the documents folder and returns the new path.
  Future<String> saveToDocuments(String tempPath) async {
    final documents = await getApplicationDocumentsDirectory();
    final dot = tempPath.lastIndexOf('.');
    final extension = dot == -1 ? '.jpg' : tempPath.substring(dot);
    final fileName = 'spot_${DateTime.now().millisecondsSinceEpoch}$extension';
    final saved = await File(tempPath).copy('${documents.path}/$fileName');
    return saved.path;
  }
}
