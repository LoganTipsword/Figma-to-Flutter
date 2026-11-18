import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../view_models/photos_view_model.dart';
import '../widgets/widgets.dart';

// Shows what the camera sees, with a button that takes a photo and saves it.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.photosViewModel});

  // The home screen's ViewModel, so the gallery sees the same photos
  final PhotosViewModel photosViewModel;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller; // null until we've found a camera
  String? _problem; // Why the camera couldn't start, if it couldn't
  bool _isTakingPhoto = false;

  @override
  void initState() {
    super.initState();
    _startCamera();
  }

  @override
  void dispose() {
    _controller?.dispose(); // Turn the camera off when the screen closes
    super.dispose();
  }

  Future<void> _startCamera() async {
    try {
      // 1. Which cameras does this device have? (Chrome asks for permission here)
      final List<CameraDescription> cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException('noCamera', 'No camera found');
      }

      // 2. Use the camera on the back of a phone; a laptop only has one
      final CameraDescription camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      // 3. Turn it on (phones ask for permission here)
      _controller = CameraController(
        camera,
        ResolutionPreset.medium, // Big enough to see, small enough to store lots
        enableAudio: false, // Photos only, so don't ask for the microphone
      );
      await _controller!.initialize();
    } on CameraException catch (error) {
      // Phones report 'CameraAccessDenied'. Chrome doesn't always say why it failed.
      _problem = error.code.startsWith('CameraAccess')
          ? 'Camera permission was denied'
          : "Couldn't start the camera. Check that camera permission is allowed.";
    }

    if (mounted) {
      setState(() {}); // Redraw: either the preview or the problem
    }
  }

  Future<void> _takePhoto() async {
    // Grab this now: after the await, this screen might already be closed
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isTakingPhoto = true);

    String message;
    try {
      final XFile file = await _controller!.takePicture();
      final Uint8List bytes = await file.readAsBytes();
      final bool saved = await widget.photosViewModel.addPhoto(bytes);
      message = saved ? 'Photo saved' : "Couldn't save the photo";
    } catch (error) {
      message = "Couldn't take the photo";
    }

    messenger.showSnackBar(SnackBar(content: Text(message)));
    if (mounted) {
      setState(() => _isTakingPhoto = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isReady = _controller?.value.isInitialized ?? false;

    // Rebuilds when a new photo is saved, so the count goes up
    return ListenableBuilder(
      listenable: widget.photosViewModel,
      builder: (context, child) {
        final int count = widget.photosViewModel.photos.length;

        return Scaffold(
          appBar: const AppHeader(title: 'Ghost Camera'),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Center(
                      child: isReady
                          ? CameraPreview(_controller!)
                          : _problem != null
                              ? Text(
                                  _problem!,
                                  style: textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                )
                              : const CircularProgressIndicator(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    count == 1 ? '1 photo saved' : '$count photos saved',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    // null turns the button off until the camera is ready
                    onPressed: isReady && !_isTakingPhoto ? _takePhoto : null,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take photo'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}