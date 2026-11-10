import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/database_helper.dart';
import '../models/food_spot.dart';
import '../services/camera_service.dart';
import '../services/location_service.dart';
import '../services/speech_service.dart';
import '../widgets/spot_image.dart';

/// Form to create a new food spot.
class AddSpotScreen extends StatefulWidget {
  const AddSpotScreen({super.key});

  @override
  State<AddSpotScreen> createState() => _AddSpotScreenState();
}

class _AddSpotScreenState extends State<AddSpotScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  final CameraService _cameraService = CameraService();
  final SpeechService _speechService = SpeechService();
  final LocationService _locationService = LocationService();
  String? _tempImagePath;
  bool _isSaving = false;
  bool _speechReady = false;
  bool _isListening = false;
  String _textBeforeDictation = '';

  @override
  void dispose() {
    _speechService.stopListening();
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  /// Shows an error message without leaving the screen.
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Picks a photo from the camera or gallery and shows it as preview.
  Future<void> _pickImage(ImageSource source) async {
    try {
      final path = await _cameraService.pickImage(source);
      if (!mounted || path == null) return;
      setState(() => _tempImagePath = path);
    } catch (e) {
      if (!mounted) return;
      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Starts or stops voice dictation for the review field.
  Future<void> _toggleDictation() async {
    if (_isListening) {
      await _speechService.stopListening();
      return;
    }

    if (!_speechReady) {
      _speechReady = await _speechService.initialize((listening) {
        if (mounted) setState(() => _isListening = listening);
      });
      if (!mounted) return;
      if (!_speechReady) {
        _showMessage('Microphone not available or permission denied. You can type the review instead.');
        return;
      }
    }

    _textBeforeDictation = _reviewController.text.trim();
    try {
      await _speechService.startListening((words) {
        if (!mounted) return;
        setState(() {
          _reviewController.text = '$_textBeforeDictation $words'.trim();
        });
      });
    } catch (e) {
      if (!mounted) return;
      _showMessage('Could not start dictation: $e');
    }
  }

  /// Validates the form, saves the spot and returns to the list.
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      String? imagePath;
      if (_tempImagePath != null) {
        imagePath = await _cameraService.saveToDocuments(_tempImagePath!);
      }

      double? latitude;
      double? longitude;
      try {
        final position = await _locationService.getCurrentPosition();
        latitude = position?.latitude;
        longitude = position?.longitude;
      } catch (e) {
        if (mounted) {
          _showMessage('Saved without location: ${e.toString().replaceFirst('Exception: ', '')}');
        }
      }

      final spot = FoodSpot(
        name: _nameController.text.trim(),
        review: _reviewController.text.trim(),
        imagePath: imagePath,
        latitude: latitude,
        longitude: longitude,
        createdAt: DateTime.now().toIso8601String(),
      );
      await DatabaseHelper.instance.insertSpot(spot);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showMessage('Could not save the spot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New food spot')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SpotImage(imagePath: _tempImagePath, height: 200),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isSaving ? null : () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isSaving ? null : () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Place name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter the name of the place';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Review',
                  helperText: _isListening ? 'Listening... tap the mic to stop' : 'Type or tap the mic to dictate',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: _isSaving ? null : _toggleDictation,
                    tooltip: 'Dictate review',
                    icon: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: _isListening ? Colors.red : null,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Write a short review';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
