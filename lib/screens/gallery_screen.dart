import 'package:flutter/material.dart';

import '../models/photo.dart';
import '../view_models/photos_view_model.dart';
import '../widgets/widgets.dart';
import 'photo_viewer_screen.dart';

// A grid of small versions (thumbnails) of every photo taken with the app, newest first.
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key, required this.photosViewModel});

  final PhotosViewModel photosViewModel;

 // Opens one photo full screen. Its close button comes back here.
  void _openPhoto(BuildContext context, Photo photo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true, // Slides up from the bottom, like a photo app
        builder: (context) => PhotoViewerScreen(
          photo: photo,
          photosViewModel: photosViewModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const AppHeader(title: 'Ghostly Gallery'),
      body: ListenableBuilder(
        listenable: photosViewModel,
        builder: (context, child) {
          final List<Photo> photos = photosViewModel.photos;

          if (photosViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (photosViewModel.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  photosViewModel.errorMessage!,
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (photos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'No photos yet. Use the camera button to take one!',
                  style: textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12.0),
            // As many columns as fit, each at most 150 wide: 2–3 on a phone, more in Chrome
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final Photo photo = photos[index];
              return GestureDetector(
                onTap: () => _openPhoto(context, photo),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.memory(
                      photo.bytes,
                      fit: BoxFit.cover, // Fill the square, trimming the edges
                      cacheWidth: 300, // Decode a small copy: a thumbnail, not the full photo
                      semanticLabel: photo.description,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}