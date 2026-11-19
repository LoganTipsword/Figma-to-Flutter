import 'package:flutter/material.dart';

import '../models/photo.dart';
import '../view_models/photos_view_model.dart';

// One photo, as big as the screen allows, with a close button and a delete button.
class PhotoViewerScreen extends StatelessWidget {
  const PhotoViewerScreen({
    super.key,
    required this.photo,
    required this.photosViewModel,
  });

  final Photo photo;
  final PhotosViewModel photosViewModel;

  Future<void> _confirmDelete(BuildContext context) async {
    // Grab these now: after the awaits, this screen might already be closed
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    // Ask first: a deleted photo can't come back
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this photo?'),
        content: const Text("It will be gone for good."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return; // Cancel, or tapped outside the dialog
    }

    final bool deleted = await photosViewModel.deletePhoto(photo);
    if (deleted) {
      navigator.pop(); // Back to the gallery: this photo is gone
    }
    messenger.showSnackBar(
      SnackBar(content: Text(deleted ? 'Photo deleted' : "Couldn't delete the photo")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(), // Back to the gallery
          icon: const Icon(Icons.close),
          tooltip: 'Close',
        ),
        actions: [
          IconButton(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete photo',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          // Pinch (or scroll in Chrome) to zoom in, drag to look around
          child: InteractiveViewer(
            child: Image.memory(
              photo.bytes,
              fit: BoxFit.contain, // The whole photo, nothing trimmed
              semanticLabel: photo.description,
            ),
          ),
        ),
      ),
    );
  }
}